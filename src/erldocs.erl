-module(erldocs).

-export([build/0, index/0 ]).

-export([bottom/0, top/0, head/0 ]).

-define(OTP_SRC, "/home/dale/otp_src_R13B").
-define(ROOT, "/home/dale/lib/erldocs.com").

buildable() ->
    [ erlref ].

build() ->
    build(?OTP_SRC).
build(Src) -> 
    ok = build(Src, find_docs(Src)).


build(_Otp, []) ->
    ok;
build(Otp, [ DocSrc | Rest]) ->

    [File, "src", "doc", App | Path]
        = lists:reverse(string:tokens(DocSrc, "/")),
    
    Root = string:join(lists:reverse(Path), "/")++"/"++App++"/doc/src",

    file:set_cwd(Root),

    try 
        Opts = [ {space, normalize}, {encoding, "latin1"},
                 {fetch_path, [Otp++"/lib/docbuilder/dtd/"]}],
        {Type, _Attr, Content} = simplexml_read_file(DocSrc, Opts),
        
        case lists:member(Type, buildable()) of
            false -> ok;
            true  ->
                OutDir = ?ROOT++"/www/"++App++"/",
                ok = filelib:ensure_dir(OutDir),
                %%Xml = strip_whitespace(Content),
                Mod = filename:basename(File, ".xml"),
                render(Type, App, Mod, Content)
                %                io:format("~p ~n",[Xml])
                %docb_transform:file(DocSrc, [{outdir, OutDir},
                %                             {html_mod, ?MODULE}])       
        end
    catch
        Error:Reason ->
            io:format("Error: ~p~n~p : ~p~n",[DocSrc, Error, Reason])
    end,
    
    file:set_cwd(?ROOT),
    
    build(Otp, Rest).

render(erlref, App, Mod, Xml) ->

%    Html = render(fun tr_erlref/1, Xml),
%    to_string(Html).
    Html = erlref_wrap(render(fun tr_erlref/1, Xml)),
    File = ?ROOT++"/www/"++App++"/"++Mod++".html",
    file:write_file(File, to_string(Html)).

render(Fun, List) when is_list(List) ->
    [ render(Fun, X) || X <- List ];
render(Fun, Element) ->
    case Fun(Element) of
        ignore         -> "";
        {stop, Result} -> Result;
        {NEl, NAttr, NChild} -> {NEl, NAttr, render(Fun, NChild)};
        Else -> Else
    end.

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
    {h2, [], Child};
tr_erlref({c, [], Child}) ->
    {code, [], Child};
tr_erlref({seealso, _Marker, Child}) ->
    {span, [{class, "seealso"}], Child};
tr_erlref({desc, [], Child}) ->
    {p, [{class, "description"}], Child};
tr_erlref({description, [], Child}) ->
     {p, [{class, "description"}], Child};
tr_erlref({funcs, [], Child}) ->
    {'div', [{class,"functions"}], [{h3, [], ["Functions"]} | Child]};
tr_erlref({func, [], Child}) ->
    {'div', [{class,"function"}], Child};
tr_erlref({tag, [], Child}) ->
    {'div', [{class,"tag"}], Child};
tr_erlref({item, [], Child}) ->
    {'div', [{class,"item"}], Child};

tr_erlref({name, [], Child}) ->
    {h3, [], Child};
tr_erlref({fsummary, [], _Child}) ->
    ignore;

tr_erlref(Else) ->
    Else.

index() ->
    index(?OTP_SRC).
index(Src) ->
    Index = index(Src, find_docs(Src), []),
    Str = lists:flatten(io_lib:format("~p",[Index])),
    Js  = lists:flatten(io_lib:format("var index = ~s;",[Str])),
    file:write_file(?ROOT++"/www/erldocs_index.js", Js), 
    ok.

index(_Otp, [], Acc) ->
    Acc;

index(Otp, [ DocSrc | Rest], Acc) ->
    
    [_File | Path] = lists:reverse(string:tokens(DocSrc, "/")),
    Root = string:join(lists:reverse(Path), "/"),
    
    file:set_cwd(Root),
    NewAcc = case do_index(Otp, DocSrc) of
                 ignore -> Acc;
                 Else   -> lists:append(Else, Acc)
             end,
    file:set_cwd(?ROOT),
    
    index(Otp, Rest, NewAcc).

do_index(Otp, Src) ->

    [_File, "src", "doc", App | _Path]
        = lists:reverse(string:tokens(Src, "/")),
    
    Opts = [ {space, normalize}, {encoding, "latin1"},
             {fetch_path, [Otp++"/lib/docbuilder/dtd/"]}],
    {Typ, _Attr, Content} = simplexml_read_file(Src, Opts),
        
    case lists:member(Typ, buildable()) of
        false -> ignore;
        true  ->
            Xml = strip_whitespace(Content),
            
            {module, [], Module} = lists:keyfind(module, 1, Xml),
            {modulesummary, [], [Sum]} = lists:keyfind(modulesummary, 1, Xml),
            
            Mod  = string:join(Module, ""),
            Funs = get_funs(App, Mod, lists:keyfind(funcs, 1, Xml)),
            
            [ ["mod", App, Mod, string:substr(Sum, 1, 50)]
              |  Funs]    
    end.

get_funs(_App, _Mod, false) ->
    [];
get_funs(App, Mod, {funcs, [], Funs}) ->
    lists:foldl(
      fun(X, Acc) ->
              lists:append(fun_stuff(App, Mod, X), Acc)
      end, [], Funs).
    
fun_stuff(App, Mod, {func, [], Child}) ->
    
    {fsummary, [], Xml} = lists:keyfind(fsummary, 1, Child),
    Summary = string:substr(to_string(Xml), 1, 50),
    
    F = fun({name, [], Name}, Acc) ->
                case make_name(Mod, Name) of
                    ignore -> Acc;
                    NName  -> [ ["fun", App, NName, Summary] | Acc ]
                end;
           (_Else, Acc) -> Acc
        end,
    
    lists:foldl(F, [], Child).

make_name(Mod, Name) ->
    Tmp = lists:flatten(Name),
    case string:chr(Tmp, 40) of
        0 ->
            ignore;
        Pos ->
            {Name2, _Rest2} = lists:split(Pos-1, Tmp),
            Mod ++ ":" ++ Name2 ++ "/"
    end.
                 
to_string(Xml) ->
    lists:flatten(xmerl:export_simple(Xml, xmerl_xml, [{prolog,[]}])).

strip_whitespace(List) when is_list(List) ->
    [ strip_whitespace(X) || X <- List, X =/= " "];
strip_whitespace({El,Attr,Children}) ->
    {El, Attr, strip_whitespace(Children)};
strip_whitespace(Else) ->
    Else.
    
find_docs(OtpSrc) ->
    F = fun(List, Acc) -> lists:append(List, Acc) end,
    AppDirs = [ find_app_docs(OtpSrc, X)
                || X <- filelib:wildcard(OtpSrc++"/lib/*/"),
                   filelib:is_dir(X) ],
    lists:foldl(F, [], AppDirs).

find_app_docs(OtpSrc, Src) ->    
    [ App | _Rest] = lists:reverse(string:tokens(Src, "/")),
    AppDocRoot = OtpSrc++"/lib/"++App++"/doc/src/",
    filelib:wildcard(AppDocRoot++"*.xml").

simplexml_read_string(Str, Opts) ->
    {XML,_Rest} = xmerl_scan:string(Str, Opts),
    xmerl_lib:simplify_element(XML).

simplexml_read_file(File, Opts) ->
    {ok, Bin} = file:read_file(File),
    simplexml_read_string(binary_to_list(Bin), Opts).

erlref_wrap(Xml) ->
    [{html, [], [        
                         {head, [], [
                                     {meta,  [{charset, "utf-8"}], []},
                                     {title, [], ["bleh"]},
                                      {link,  [{type, "text/css"}, {rel, "stylesheet"},
                                               {href, "../erldocs.css"}], []}
                                     ]},
                         
                          {body, [], [
                   
                                      {'div', [{id, "sidebar"}], [
                                                                  {input, [{type, "text"}, {value,"Search"}, {id, "search"},
                                                                           {autocomplete, "off"}], []},
                                                                  {ul, [{id, "results"}], []}     
                                                                 ]},
                                      {'div', [{id, "content"}], Xml},
                                      {script, [{src, "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.js"}], [" "]},
                                      {script, [{src, "../erldocs_index.js"}], [" "]},
                                      {script, [{src, "../erldocs.js"}], [" "]}
                                     ]}
                         ]}].

%% erlref_wrap(Xml) ->
%%     [{html, [], [
%%                  {head, [], [
%%                                       {meta,  [{charset, "utf-8"}], []},
%%                                       {title, [], ["bl]}
                             
%%                             ]},
%%                  {p, [], Xml}
                 
%%                 ] }].

head() ->
    "<link rel='stylesheet' href='../erldocs.css' type='text/css'>".

top() ->
    "<div id='sidebar'>"
        "<input type='text' value='Search' id='search' autocomplete='off' />"
        "<ul id='results'></ul>"
        "</div>".

bottom() ->
    "<script src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.js'"
        "></script>"
        "<script src='../erldocs_index.js'></script>"
        "<script src='../erldocs.js'></script>".
