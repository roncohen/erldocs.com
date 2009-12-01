-module(erldocs).

-export([ all/3, make_name/1 ]).


all(OtpSrc, Dest, StaticSrc) ->
    
    Fun = fun(Current, Acc) ->
                  all(OtpSrc, Dest, Acc, Current)
          end,
    
    Index = lists:foldl(Fun, [], find_docs(OtpSrc)),

    ok = module_index(Dest, Index),
    ok = javascript_index(Dest, Index),

    [ {ok, _Bytes} = file:copy(StaticSrc++"/"++File, Dest++"/"++File) ||
        File <- ["erldocs.js", "erldocs.css", "jquery.js", "favicon.ico"] ], 
    
    ok.

all(OtpSrc, Dest, Acc, File) ->
    
    {Type, _Attr, Content} = read_xml(OtpSrc, File, [{space, normalize}]),
    
    case lists:member(Type, buildable()) of
        false -> Acc;
        true  ->

            [FName, "src", "doc", App | _Path]
                = lists:reverse(filename:split(File)),

            % Render File
            Mod = filename:basename(FName, ".xml"),
            render(Type, Dest, App, Mod, Content),

            % Add Index
            Xml = strip_whitespace(Content),
            
            {module, [], Module}       = lists:keyfind(module, 1, Xml),
            {modulesummary, [], [Sum]} = lists:keyfind(modulesummary, 1, Xml),

            % strip silly shy characters
            NMod  = [ X || X <- string:join(Module, ""), X =/= 173],
            Funs = get_funs(App, Mod, lists:keyfind(funcs, 1, Xml)),

            case lists:member({App, NMod}, ignore()) of
                true -> Acc;
                false -> lists:append([ ["mod", App, NMod, Sum, Mod] |  Funs],
                                      Acc)
            end
    end.
    
module_index(Dest, Index) ->
    Mods  = lists:filter(fun(["mod"|_]) -> true; (_) -> false end, Index),
    SMods = lists:reverse(lists:sort(Mods)),
    Xml   = [{h1, [], ["Module Index"]},
             {hr, [], []}, {br, [], []},
             {'div', [], module_ind(SMods, [])}],
    
    Html    = erlref_wrap("Module Index", Xml, ""),
    HtmlStr = xml_to_str(Html, "<!DOCTYPE html>"),
    File    = filename:join([Dest, "index.html"]),
    ok      = file:write_file(File, HtmlStr).
    
module_ind([], Acc) ->
    Acc;
module_ind([["mod", App, Mod, Summary, Src]|Tail], Acc) ->
    Html = {p, [], [{a, [{href, App++"/"++Src++".html"}], [Mod]},
                    {br, [], []}, Summary]},
    module_ind(Tail, [Html | Acc]).

javascript_index(Dest, FIndex) ->

    F = fun(["mod", App, _Mod, Sum, Mod]) ->
                ["mod", App, Mod, string:substr(Sum, 1, 50)];
           ([Else, App, NMod, Sum]) ->
                [Else, App, NMod, string:substr(Sum, 1, 50)]
        end,
    Index = [ F(X) || X<-FIndex ],
     
    Sort = fun(["app" | _Rest1], ["mod" | _Rest2]) -> true;
              (["app" | _Rest1], ["fun" | _Rest2]) -> true;
              (["mod" | _Rest1], ["fun" | _Rest2]) -> true;
              (["mod", _, M1, _], ["mod", _, M2, _]) ->
                   string:to_lower(M1) < string:to_lower(M2);
              (_, _) ->
                   false
           end,

    % Heh, cheating, will probably break
    Js = format("var index = ~p;",[lists:sort(Sort, Index)]),
    
    File = filename:join([Dest, "erldocs_index.js"]),
    ok   = file:write_file(File, Js).

ignore() ->
    [{"kernel", "init"},
     {"kernel", "zlib"},
     {"kernel", "erlang"},
     {"kernel", "erl_prim_loader"}].

format(Str, Args) ->
    lists:flatten(io_lib:format(Str, Args)).

% Read an xml file, need to cd into the xml directory because files
% are addressed relative to it, and cd back to everything else works
read_xml(Src, XmlFile, Opts) ->
    
    {ok, Pwd} = file:get_cwd(),
    file:set_cwd(filename:dirname(XmlFile)),
    
    NOpts  = [{fetch_path, [Src++"/lib/docbuilder/dtd/"]},
              {encoding,   "latin1"}] ++ Opts,
    try 
        {ok, Bin}    = file:read_file(XmlFile),
        {Xml, _Rest} = xmerl_scan:string(binary_to_list(Bin), NOpts),
        file:set_cwd(Pwd),    
        xmerl_lib:simplify_element(Xml)
    catch
        _:Err ->
            file:set_cwd(Pwd),
            exit({error, XmlFile, Err})
    end.


render(erlref, Dest, App, Mod, Xml) ->
    
    File = filename:join([Dest, App, Mod++".html"]),
    ok   = filelib:ensure_dir(filename:dirname(File)++"/"),

    {_Acc, NXml} = render(fun tr_erlref/2, Xml, [{ids,[]}, {list, ul}]),
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
            Name3 = lists:last(string:tokens(Name2, ":")),
            Args = string:substr(Rest2, 2, string:chr(Rest2, 41) - 2),
            NArgs = length(string:tokens(Args, ",")),
            Name3 ++ "/" ++ integer_to_list(NArgs)
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

find_docs(OtpSrc) ->
    
    %OtpSrc = root() ++ "/erlsrc/" ++ Otp,
    Docs = [ filelib:wildcard(Src ++ "/doc/src/*.xml")
             || Src <- filelib:wildcard(OtpSrc++"/lib/*/"),
                filelib:is_dir(Src) ],

    Erts = filelib:wildcard(OtpSrc ++ "/erts/doc/src/*.xml"),

    lists:foldl(fun lists:append/2, [], Docs) ++ Erts.

% eugh: template to wrap pages in
erlref_wrap(Module, Xml, Base) ->
    [
     {html, [{lang, "en"}],
      ["\n",
       {head, [],
        [
         {meta,  [{charset, "utf-8"}], []},"\n",
         {title, [], [Module ++ " - erldocs.com (Erlang Documentation)"]},"\n",
         {link,  [{type, "text/css"}, {rel, "stylesheet"},
                  {href, Base++"erldocs.css"}], []}, "\n"
        ]},
       {body, [],
        [
         {'div', [{id, "sidebar"}],
          [
           {input, [{type, "text"}, {value,"Loading..."}, {id, "search"},
                    {autocomplete, "off"}], []},
           {ul, [{id, "results"}], [" "]}
          ]},
         {'div', [{id, "content"}], Xml},
         {script, [{src, Base++"jquery.js"}], [" "]},
         {script, [{src, Base++"erldocs_index.js"}], [" "]},
         {script, [{src, Base++"erldocs.js"}], [" "]},
         {script, [{type, "text/javascript"}],
          ["var gaJsHost = ((\"https:\" == document.location.protocol) "
           "? \"https://ssl.\" : \"http://www.\"); document.write("
           "unescape(\"%3Cscript src='\" + gaJsHost + \"google-analytics"
           ".com/ga.js' type='text/javascript'%3E%3C/script%3E\"));"]},
         {script, [{type, "text/javascript"}],
          ["try { var pageTracker = _gat._getTracker(\"UA-59760-14\");"
           "pageTracker._trackPageview();} catch(err) {}"]}        
        ]}
      ]}].

add_html("#"++Rest) ->
    "#"++Rest;
add_html(Link) ->
    case string:tokens(Link, "#") of
        [Tmp]    -> Tmp++".html";
        [N1, N2] -> lists:flatten([N1, ".html#", N2])
    end.     

% Transforms erlang xml format to html
tr_erlref({header,[],_Child}, _Acc) ->
    ignore;
tr_erlref({marker, [{id, Marker}], []}, _Acc) ->
    {span, [{id, Marker}], [" "]};
tr_erlref({term,[{id, Term}], _Child}, _Acc) ->
    Term;
tr_erlref({module,[],Module}, _Acc) ->
    {h1, [], [lists:flatten(Module)]};
tr_erlref({modulesummary, [], Child}, _Acc) ->
    {h2, [{class, "modsummary"}], Child};
tr_erlref({c, [], Child}, _Acc) ->
    {code, [], Child};
tr_erlref({section, [], Child}, _Acc) ->
    {'div', [{class, "section"}], Child};
tr_erlref({title, [], Child}, _Acc) ->
    {h4, [], [Child]};
tr_erlref({type, [], Child}, _Acc) ->
    {ul, [{class, "type"}], Child};
tr_erlref({v, [], []}, _Acc) ->
    {li, [], [" "]};
tr_erlref({v, [], Child}, _Acc) ->
    {li, [], [{code, [], Child}]};
tr_erlref({seealso, [{marker, Marker}], Child}, _Acc) ->
    N = case string:tokens(Marker, ":") of
	    [Tmp]     -> add_html(Tmp);
	    [Ap | Md] ->  "../"++Ap++"/" ++ add_html(lists:flatten(Md))
	end,
    {a, [{href, N}, {class, "seealso"}], Child};
tr_erlref({desc, [], Child}, _Acc) ->
    {'div', [{class, "description"}], Child};
tr_erlref({description, [], Child}, _Acc) ->
    {'div', [{class, "description"}], Child};
tr_erlref({funcs, [], Child}, _Acc) ->
    {'div', [{class,"functions"}], [{h4, [], ["Functions"]}, {hr, [], []} | Child]};
tr_erlref({func, [], Child}, _Acc) ->
    {'div', [{class,"function"}], Child};
tr_erlref({tag, [], Child}, _Acc) ->
    {dt, [], Child};
tr_erlref({taglist, [], Child}, [Ids, _List]) ->
    { {dl, [], Child}, [Ids, {list, dl}] };
tr_erlref({input, [], Child}, _Acc) ->
    {code, [], Child};
tr_erlref({item, [], Child}, [_Ids, {list, dl}]) ->
    {dd, [], Child};
tr_erlref({item, [], Child}, [_Ids, {list, ul}]) ->
    {li, [], Child};
tr_erlref({list, _Type, Child}, [Ids, _List]) ->
    { {ul, [], Child}, [Ids, {list, ul}] };
tr_erlref({code, [{type, "none"}], Child}, _Acc) ->
    {pre, [{class, "sh_erlang"}], Child};
tr_erlref({pre, [], Child}, _Acc) ->
    {pre, [{class, "sh_erlang"}], Child};
tr_erlref({note, [], Child}, _Acc) ->
    {'div', [{class, "note"}], [{h2, [], ["Note!"]} | Child]};
tr_erlref({warning, [], Child}, _Acc) ->
    {'div', [{class, "warning"}], [{h2, [], ["Warning!"]} | Child]};
tr_erlref({name, [], Child}, Acc) ->
    case make_name(Child) of
        ignore -> ignore;
        Name   ->
	    [{ids, Ids}, List] = Acc,
	    NName = inc_name(Name, Ids, 0),
	    { {h3, [{id, NName}], [Child]},     
              [{ids, [NName | Ids]}, List]}
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
    
