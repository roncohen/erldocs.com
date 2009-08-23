-module(erldocs).

-export([ all/1, module_index/1 ]).

all(Otp) ->
    
    ok = build(Otp),
    ok = javascript_index(Otp),
    ok = module_index(Otp),
    
    % Generate index page
    [Name | _Rest] = lists:reverse(string:tokens(Otp, "_")),
    
    Html    = erlref_wrap("Home", index_tpl(Name, ""), ""),
    File    = filename:join([root(), "www", Otp, "index.html"]),
    HtmlStr = xml_to_str(Html, "<!DOCTYPE html>"),
    ok = file:write_file(File, HtmlStr).

% Build the documentation files
build(Src) ->
    [ ok = build(Src, File) || File <- find_docs(Src) ],
    ok.

build(Otp, DocSrc) ->
    
    {Type, _Attr, Content} = read_xml(root(), Otp, DocSrc),
    
    case lists:member(Type, buildable()) of
        false -> ok;
        true  ->
            [File, "src", "doc", App | _Path]
                = lists:reverse(filename:split(DocSrc)),
            Mod = filename:basename(File, ".xml"),
            render(Type, root(), Otp, App, Mod, Content)
    end.

module_index(Otp) ->
    Index = index(Otp, find_docs(Otp), [], long),
    Mods  = lists:filter(fun(["mod"|_]) -> true; (_) -> false end, Index),
    SMods = lists:reverse(lists:sort(Mods)),
    Xml = [{h1, [], ["Module Index"]},
           {hr, [], []}, {br, [], []},
           {'div', [], module_index(SMods, [])}],

    Html  = erlref_wrap("Module Index", Xml, ""),
    HtmlStr = xml_to_str(Html, "<!DOCTYPE html>"),
    File = filename:join([root(), "www", Otp, "module_index.html"]),
    ok   = file:write_file(File, HtmlStr).
    
module_index([], Acc) ->
    Acc;
module_index([["mod", App, Mod, Summary]|Tail], Acc) ->
    Html = {p, [], [{a, [{href, App++"/"++Mod++".html"}], [Mod]},
                    {br, [], []}, Summary]},
    module_index(Tail, [Html | Acc]).

javascript_index(Otp) ->
    
    Sort = fun(["app" | _Rest1], ["mod" | _Rest2]) -> true;
              (["app" | _Rest1], ["fun" | _Rest2]) -> true;
              (["mod" | _Rest1], ["fun" | _Rest2]) -> true;
              (_, _) -> false
           end,

    Index = index(Otp, find_docs(Otp), [], short),
    % Heh, cheating, will probably break
    Js = format("var index = ~p;",[lists:sort(Sort, Index)]),
    
    File = filename:join([root(), "www", Otp, "erldocs_index.js"]),
    ok   = file:write_file(File, Js).

index(_Otp, [], Acc, _Summary) ->
    Acc;

index(Otp, [ DocSrc | Rest], Acc, Summary) ->
    NewAcc = case do_index(Otp, DocSrc, Summary) of
                 ignore -> Acc;
                 Else   -> lists:append(Else, Acc)
             end,
    index(Otp, Rest, NewAcc, Summary).

do_index(Otp, Src, Summary) ->
    
    {Type, _Attr, Content}
        = read_xml(root(), Otp, Src, [{space, normalize}]),
    
    case lists:member(Type, buildable()) of
        false -> ignore;
        true  ->
            
            [_File, "src", "doc", App | _Path]
                = lists:reverse(filename:split(Src)),
            Xml = strip_whitespace(Content),
            
            {module, [], Module}       = lists:keyfind(module, 1, Xml),
            {modulesummary, [], [Sum]} = lists:keyfind(modulesummary, 1, Xml),
            
            % strip silly shy characters
            Mod  = [ X || X <- string:join(Module, ""), X =/= 173],
            Funs = get_funs(App, Mod, lists:keyfind(funcs, 1, Xml)),
            Sum2 = case Summary of
                       short -> string:substr(Sum, 1, 50);
                       long  -> Sum
                   end,
            
            [ ["mod", App, Mod, Sum2] |  Funs]    
    end.

format(Str, Args) ->
    lists:flatten(io_lib:format(Str, Args)).

% Read an xml file, need to cd into the xml directory because files
% are addressed relative to it, and cd back to everything else works
read_xml(Root, Otp, XmlFile) ->
    read_xml(Root, Otp, XmlFile, []).

read_xml(Root, Otp, XmlFile, Opts) ->
    
    file:set_cwd(filename:dirname(XmlFile)),
    
    OtpSrc = filename:join([Root, "erlsrc", Otp]),
    NOpts  = [{fetch_path, [OtpSrc++"/lib/docbuilder/dtd/"]},
              {encoding,   "latin1"}] ++ Opts,
    
    {ok, Bin}    = file:read_file(XmlFile),
    {Xml, _Rest} = xmerl_scan:string(binary_to_list(Bin), NOpts),
    
    file:set_cwd(filename:join([Root, "src"])),    
    
    xmerl_lib:simplify_element(Xml).


render(erlref, Root, Otp, App, Mod, Xml) ->
    
    File = filename:join([Root, "www", Otp, App, Mod++".html"]),
    ok   = filelib:ensure_dir(filename:dirname(File)++"/"),

    {_Acc, NXml} = render(fun tr_erlref/2, Xml, []),
    Html    = erlref_wrap(Mod, NXml, "../"),
    HtmlStr = xml_to_str(Html, "<!DOCTYPE html>"),
    ok = file:write_file(File, HtmlStr).

render(Fun, List, Acc) when is_list(List) ->
    case io_lib:char_list(List) of 
        true  ->
            {Acc, List};
        false ->
            F = fun(X, {Ac, L}) ->
                        {NAcc, NEl} = render(Fun, X, Ac),
                        {NAcc, [NEl | L]}
                end,
            
            {Ac, L} = lists:foldl(F, {Acc, []}, List),
            {Ac, lists:reverse(L)}
    end;

render(Fun, Element, Acc) ->

    % this is nasty
    F = fun(ignore, NAcc) -> 
                {NAcc, ""};
           ({NEl, NAttr, NChild}, NAcc) ->
                {NNAcc, NNChild} = render(Fun, NChild, NAcc),
                {NNAcc, {NEl, NAttr, NNChild}};
           (Else, NAcc) ->
                {NAcc, Else}
        end,
    
    case Fun(Element, Acc) of
        {El, NAcc} -> F(El, NAcc);
        El         -> F(El, Acc)
    end.

% List of the type of xml files erldocs can build
buildable() ->
    [ erlref ].

% bleh I hate doing this
root() ->
    {ok, Path} = file:get_cwd(),
    ["src" | Rest] = lists:reverse(filename:split(Path)),
    filename:join(lists:reverse(Rest)).

get_funs(_App, _Mod, false) ->
    [];
get_funs(App, Mod, {funcs, [], Funs}) ->
    lists:foldl(
      fun(X, Acc) -> fun_stuff(App, Mod, X) ++ Acc end,
      [], Funs).
    
fun_stuff(App, Mod, {func, [], Child}) ->
    
    {fsummary, [], Xml} = lists:keyfind(fsummary, 1, Child),
    Summary = string:substr(xml_to_str(Xml, []), 1, 50),
    
    F = fun({name, [], Name}, Acc) ->
                case make_name(Name) of
                    ignore -> Acc;
                    NName  -> [ ["fun", App, Mod++":"++NName, Summary] | Acc ]
                end;
           (_Else, Acc) -> Acc
        end,
    
    lists:foldl(F, [], Child).

make_name(Name) ->
    Tmp = lists:flatten(Name),
    case string:chr(Tmp, 40) of
        0 ->
            io:format("wtf ~p~n",[Name]),
            ignore;
        Pos ->
            {Name2, Rest2} = lists:split(Pos-1, Tmp),
            Args = string:substr(Rest2, 2, string:chr(Rest2, 41) - 2),
            NArgs = length(string:tokens(Args, ",")),
            Name2 ++ "/" ++ integer_to_list(NArgs)
    end.

xml_to_str(Xml, Prolog) ->
    Prolog ++ xml_to_html(Xml).
%    lists:flatten(xmerl:export_simple(Xml, xmerl_xml, [{prolog, Prolog}])).

strip_whitespace(List) when is_list(List) ->
    [ strip_whitespace(X) || X <- List, X =/= " "];
strip_whitespace({El,Attr,Children}) ->
    {El, Attr, strip_whitespace(Children)};
strip_whitespace(Else) ->
    Else.

find_docs(Otp) ->
    
    OtpSrc = root() ++ "/erlsrc/" ++ Otp,
    Docs = [ filelib:wildcard(Src ++ "/doc/src/*.xml")
             || Src <- filelib:wildcard(OtpSrc++"/lib/*/"),
                filelib:is_dir(Src) ],

    Erts = filelib:wildcard(OtpSrc ++ "/erts/doc/src/*.xml"),
    
    lists:foldl(fun lists:append/2, [], Docs) ++ Erts.

info(Base) ->
    [
     {p, [], ["erldocs.com is an alternative to the official erlang documentation, "
              "created by Dale Harvey. All content is &copy; Ericsson."]},
     {p, [],
      ["The source code can be found on ",
       {a, [{href,"http://github.com/daleharvey/erldocs.com/tree/master"},
            {target, "_blank"}],
        ["Github"]},
       ",  you can email me at ",
       {a, [{href,"mailto:dale@arandomurl.com"}], ["dale@arandomurl.com"]},
       " for bug reports / feature requests or just feedback :)"
      ]},
     {em, [], ["Alternative Erlang Versions"]},
     {ul, [], [{li, [], [{a, [{href,"/otp_src_R13B/"}], ["R13B"]}]}]},
     {br, [], []},
     {em, [], ["Other Places:"]},
     {ul, [],
      [{li, [],
        [{a, [{href,"http://www.erlang.org/doc/"},{target, "_blank"}],
          ["http://www.erlang.org/doc/"]},
         {br, [], []},
         "The official erlang documentation"]},
       {li, [],
        [{a, [{href,"http://learnyousomeerlang.com/"},{target, "_blank"}],
          ["http://learnyousomeerlang.com/"]},
         {br, [], []},
         "A beginners guide to erlang"]},
       {li, [],
        [{a, [{href,Base++"module_index.html"}], ["module_index.html"]},
         {br, [], []},
         "A static index of erlang modules"]}]}
    ].

% eugh: template to wrap pages in
erlref_wrap(Module, Xml, Base) ->
    [
     {html, [{lang, "en"}],
      ["\n",
       {head, [],
        [
         {meta,  [{charset, "utf-8"}], []},"\n",
         {title, [], [Module ++ " - erldocs.com"]},"\n",
         {link,  [{type, "text/css"}, {rel, "stylesheet"},
                  {href, Base++"../erldocs.css"}], []}, "\n"
        ]},
       {body, [],
        [
         {'div', [{id, "sidebar"}],
          [
           {input, [{type, "text"}, {value,"Loading..."}, {id, "search"},
                    {autocomplete, "off"}], []},
           {a, [{id, "expand"}],["▾"]},
           {'div', [{id, "sideinfo"}, {class, "info"}], info(Base)},
           {ul, [{id, "results"}], [" "]}
          ]},
         {'div', [{id, "content"}], Xml},
         {script, [{src, "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.js"}], [" "]},
         {script, [{src, Base++"erldocs_index.js"}], [" "]},
         {script, [{src, Base++"../erldocs.js"}], [" "]}
        ]}
      ]}].

index_tpl(Vsn, Base) ->
    [{h1, [], ["Erlang "++Vsn++" Documentation"]},
     {hr, [], []}, 
     {'div', [{class, "info"}], info(Base)}].

% Transforms erlang xml format to html
tr_erlref({header,[],_Child}, _Acc) ->
    ignore;
tr_erlref({section,[],_Child}, _Acc) ->
    ignore;
tr_erlref({marker, _Marker, _Child}, _Acc) ->
    ignore;
tr_erlref({type, _Marker, _Child}, _Acc) ->
    ignore;
tr_erlref({module,[],Module}, _Acc) ->
    {h1, [], [lists:flatten(Module)]};
tr_erlref({modulesummary, [], Child}, _Acc) ->
    {h2, [{class, "modsummary"}], Child};
tr_erlref({c, [], Child}, _Acc) ->
    {code, [], Child};
tr_erlref({seealso, _Marker, Child}, _Acc) ->
    {span, [{class, "seealso"}], Child};
tr_erlref({desc, [], Child}, _Acc) ->
    {'div', [{class, "description"}], Child};
tr_erlref({description, [], Child}, _Acc) ->
    {'div', [{class, "description"}], Child};
tr_erlref({funcs, [], Child}, _Acc) ->
    {'div', [{class,"functions"}], [{h2, [], ["Functions"]}, {hr, [], []} | Child]};
tr_erlref({func, [], Child}, _Acc) ->
    {'div', [{class,"function"}], Child};
tr_erlref({tag, [], Child}, _Acc) ->
    {'div', [{class,"tag"}], Child};
tr_erlref({taglist, [], Child}, _Acc) ->
    {ul, [], Child};
tr_erlref({input, [], Child}, _Acc) ->
    {code, [], Child};
tr_erlref({item, [], Child}, _Acc) ->
    {li, [], Child};
tr_erlref({pre, [], Child}, _Acc) ->
    {pre, [{class, "sh_erlang"}], Child};
tr_erlref({list, _Type, Child}, _Acc) ->
    {ul, [], Child};
tr_erlref({name, [], Child}, Acc) ->
    case make_name(Child) of
        ignore -> ignore;
        Name   -> 
	    NName = inc_name(Name, Acc, 0),
	    { {h3, [{id, NName}], [Child]},     
              [NName | Acc]}
    end;
tr_erlref({fsummary, [], _Child}, _Acc) ->
    ignore;
tr_erlref(Else, _Acc) ->
    Else.

nname(Name, 0)   -> Name;
nname(Name, Acc) -> Name ++ "-" ++ integer_to_list(Acc).

inc_name(Name, List, Acc) ->
    case lists:member(nname(Name, Acc), List) of
	true   -> inc_name(Name, List, Acc+1);
	false  -> nname(Name, Acc)
    end.

attr_to_str([]) ->
    "";
attr_to_str(List) when is_list(List) ->
    string:join([ attr_to_str(X) || X <- List ], " ");
attr_to_str({Name, Val}) ->
    atom_to_list(Name) ++ "=\""++Val++"\"".

xml_to_html({Tag, Attr, []}) ->
    lists:flatten([$<, atom_to_list(Tag), " ", attr_to_str(Attr), " />"]);
xml_to_html({Tag, [], []}) ->
    lists:flatten([$<, atom_to_list(Tag), " />"]);
xml_to_html({Tag, [], Child}) ->
    Tg = atom_to_list(Tag), 
    lists:flatten([$<, Tg, $>, xml_to_html(Child),"</", Tg, $>]);
xml_to_html({Tag, Attr, Child}) ->
    Tg = atom_to_list(Tag), 
    lists:flatten([$<, Tg, " ", attr_to_str(Attr), $>,
                   xml_to_html(Child),"</", Tg, $>]);
xml_to_html(List) when is_list(List) ->
    case io_lib:char_list(List) of
        true  -> htmlchars(List);
        false -> lists:flatten([ xml_to_html(X) || X <- List])
    end.

htmlchars(List) ->
    htmlchars(List, []).

htmlchars([], Acc) ->
    lists:flatten(lists:reverse(Acc));

htmlchars([$<|Rest], Acc) ->
    htmlchars(Rest, ["&lt;" | Acc]);
htmlchars([$>|Rest], Acc) ->
    htmlchars(Rest, ["&gt;" | Acc]);
htmlchars([160|Rest], Acc) ->
    htmlchars(Rest, ["&nbsp;" | Acc]);
htmlchars([Else|Rest], Acc) ->
    htmlchars(Rest, [Else | Acc]).
    
