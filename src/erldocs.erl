-module(erldocs).

-export([ all/1 ]).

all(Otp) ->
    
    ok = build(Otp),
    ok = index(Otp),

    % Generate index page
    Html    = erlref_wrap("index", index_tpl(), ""),
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

index(Otp) ->
    
    Sort = fun(["app" | _Rest1], ["mod" | _Rest2]) -> true;
              (["app" | _Rest1], ["fun" | _Rest2]) -> true;
              (["mod" | _Rest1], ["fun" | _Rest2]) -> true;
              (_, _) -> false
           end,

    Index = index(Otp, find_docs(Otp), []),
    % Heh, cheating, will probably break
    Js = format("var index = ~p;",[lists:sort(Sort, Index)]),
    
    File = filename:join([root(), "www", Otp, "erldocs_index.js"]),
    ok   = file:write_file(File, Js).

index(_Otp, [], Acc) ->
    Acc;

index(Otp, [ DocSrc | Rest], Acc) ->
    
    NewAcc = case do_index(Otp, DocSrc) of
                 ignore -> Acc;
                 Else   -> lists:append(Else, Acc)
             end,
    
    index(Otp, Rest, NewAcc).

do_index(Otp, Src) ->
    
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
            Summary = string:substr(Sum, 1, 50),
            
            [ ["mod", App, Mod, Summary] |  Funs]    
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

    Html    = erlref_wrap(Mod, render(fun tr_erlref/1, Xml), "../"),
    HtmlStr = xml_to_str(Html, "<!DOCTYPE html>"),
    ok = file:write_file(File, HtmlStr).

render(Fun, List) when is_list(List) ->
    case io_lib:char_list(List) of 
        true  -> List;
        false -> [ render(Fun, X) || X <- List ]
    end;

render(Fun, Element) ->
    case Fun(Element) of
        ignore               -> "";
        {stop, Result}       -> Result;
        {NEl, NAttr, NChild} -> {NEl, NAttr, render(Fun, NChild)};
        Else                 -> Else
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
            ignore;
        Pos ->
            {Name2, Rest2} = lists:split(Pos-1, Tmp),
            Args = string:substr(Rest2, 2, string:chr(Rest2, 41) - 2),
            NArgs = length(string:tokens(Args, ",")),
            Name2 ++ "/" ++ integer_to_list(NArgs)
    end.

xml_to_str(Xml, Prolog) ->
    lists:flatten(xmerl:export_simple(Xml, xmerl_xml, [{prolog, Prolog}])).

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
    lists:foldl(fun lists:append/2, [], Docs).

% eugh: template to wrap pages in
erlref_wrap(Module, Xml, Base) ->
    [{html, [{lang, "en"}], [        
       {head, [], [
         {meta,  [{charset, "utf-8"}], []},
         {title, [], [Module ++ " - erldocs.com"]},
         {link,  [{type, "text/css"}, {rel, "stylesheet"},
                  {href, Base++"../erldocs.css"}], []}
       ]},
       {body, [], [
         {'div', [{id, "sidebar"}], [
           {input, [{type, "text"}, {value,"Loading..."}, {id, "search"},
                    {autocomplete, "off"}], []},
           {ul, [{id, "results"}], [" "]},
	   {'div', [{class, "copystuff"}], [
             {span, [], [" © Ericsson, "]},
	     {a, [{target, "blank"}, {href, "http://github.com/daleharvey/erldocs.com/tree"}], ["Source (github)"]}
           ]}		     
         ]},
         {'div', [{id, "content"}], Xml},
         {script, [{src, "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.js"}], [" "]},
         {script, [{src, Base++"erldocs_index.js"}], [" "]},
         {script, [{src, Base++"../erldocs.js"}], [" "]}
       ]}
     ]}].

index_tpl() ->
    [{h2, [], ["Welome to erldocs.com"]}].

% Transforms erlang xml format to html
tr_erlref({header,[],_Child}) ->
    ignore;
tr_erlref({section,[],_Child}) ->
    ignore;
tr_erlref({marker, _Marker, _Child}) ->
    ignore;
tr_erlref({type, _Marker, _Child}) ->
    ignore;
tr_erlref({module,[],Module}) ->
    {h1, [], [lists:flatten(Module)]};
tr_erlref({modulesummary, [], Child}) ->
    {h2, [{class, "modsummary"}], Child};
tr_erlref({c, [], Child}) ->
    {code, [], Child};
tr_erlref({seealso, _Marker, Child}) ->
    {span, [{class, "seealso"}], Child};
tr_erlref({desc, [], Child}) ->
    {'div', [{class, "description"}], Child};
tr_erlref({description, [], Child}) ->
    {'div', [{class, "description"}], Child};
tr_erlref({funcs, [], Child}) ->
    {'div', [{class,"functions"}], [{h2, [], ["Functions"]}, {hr, [], []} | Child]};
tr_erlref({func, [], Child}) ->
    {'div', [{class,"function"}], Child};
tr_erlref({tag, [], Child}) ->
    {'div', [{class,"tag"}], Child};
tr_erlref({taglist, [], Child}) ->
    {ul, [], Child};
tr_erlref({input, [], Child}) ->
    {code, [], Child};
tr_erlref({item, [], Child}) ->
    {li, [], Child};
tr_erlref({list, _Type, Child}) ->
    {ul, [], Child};
tr_erlref({name, [], Child}) ->
    Name = make_name(Child),
    {h3, [{id, Name}], [Child]};
tr_erlref({fsummary, [], _Child}) ->
    ignore;
tr_erlref(Else) ->
    Else.
