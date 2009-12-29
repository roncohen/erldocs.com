-module(erldocs).

-export([ all/4 ]).

all(OtpSrc, Dest, StaticSrc, Version) ->
    
    Fun = fun(Current, Acc) ->
                  all(OtpSrc, Dest, Acc, Current, Version, StaticSrc)
          end,

    % build index and remove cos* crap
    Tmp   = lists:foldl(Fun, [], find_docs(OtpSrc)),
    Index = [X || X = [_,App|_] <- Tmp, nomatch == re:run(App, "^cos") ],

    % makes index.html
    ok = module_index(StaticSrc, Dest, Index, Version), 
    % makes erldocs_index.js
    ok = javascript_index(Dest, Index),                 

    % copy static files to individual sites
    [ {ok, _Bytes} = file:copy([StaticSrc, "/", File], [Dest,"/",File]) ||
        File <- ["erldocs.js", "erldocs.css", "jquery.js"] ], 
    
    ok.

all(OtpSrc, Dest, Acc, File, Version, Src) ->
    
    {Type, _Attr, Content} = read_xml(OtpSrc, File),
    
    case lists:member(Type, buildable()) of
        false -> Acc;
        true  ->
            [FName, "src", "doc", App | _Path]
                = lists:reverse(filename:split(File)),

            % Render File
            Mod = filename:basename(FName, ".xml"),
            render(Type, Dest, App, Mod, Content, Version, Src),
            
            % Add Index
            Xml = strip_whitespace(Content),
            {Module1, Sum2} = case Type of
                                erlref ->                    
                                      {module, [], Module}
                                          = lists:keyfind(module, 1, Xml),
                                      {modulesummary, [], Sum}
                                          = lists:keyfind(modulesummary,1, Xml),
                                      {Module, Sum};
                                  cref ->
                                      {lib, [], Module}
                                          = lists:keyfind(lib, 1, Xml),
                                      {libsummary, [], Sum}
                                          = lists:keyfind(libsummary, 1, Xml),
                                      {Module, Sum}
                              end,
            Sum1 = lists:flatten(Sum2),
            
            % strip silly shy characters
            NMod  = [ X || X <- string:join(Module1, ""), X =/= 173],
            Funs = get_funs(App, Mod, lists:keyfind(funcs, 1, Xml)),

            case lists:member({App, NMod}, ignore()) of
                true -> Acc;
                false -> lists:append([ ["mod", App, NMod, Sum1, Mod] |  Funs],
                                      Acc)
            end
    end.
    
module_index(Static, Dest, Index, Version) ->

    Mods = lists:sort( fun sort_index/2,
                       [ mod(X) || X = ["mod"|_] <- Index] ),
    Html = "<h1>Module Index</h1><hr /><br /><div>"
        ++xml_to_str(Mods)++"</div>",
    
    Args = [{base, ""},
            {title, "Module Index - "++Version},
            {content, Html}],
    
    ok = file:write_file([Dest, "/index.html"], file_tpl(Static, Args)).

mod(["mod", App, Mod, Sum, Src]) ->
    Url = App++"/"++Src++".html",
    {p,[], [{a, [{href, Url}], [Mod]}, {br,[],[]}, Sum]}.


sort_index(["app" | _], ["mod" | _])             -> true;
sort_index(["app" | _], ["fun" | _])             -> true;
sort_index(["mod" | _], ["fun" | _])             -> true;
sort_index(["mod", _, M1, _], ["mod", _, M2, _]) ->
    string:to_lower(M1) < string:to_lower(M2);
sort_index(_, _)                                 -> false.
    

javascript_index(Dest, FIndex) ->

    F = fun(["mod", App, _Mod, Sum, Mod]) ->
                ["mod", App, Mod, string:substr(Sum, 1, 50)];
           ([Else, App, NMod, Sum]) ->
                [Else, App, NMod, string:substr(Sum, 1, 50)]
        end,
    
    Index = lists:sort( fun sort_index/2, [ F(X) || X<-FIndex ] ),
    Js    = fmt("var index = ~p;", [Index]),
    
    ok = file:write_file([Dest,"/erldocs_index.js"], Js).

ignore() ->
    [{"kernel", "init"},
     {"kernel", "zlib"},
     {"kernel", "erlang"},
     {"kernel", "erl_prim_loader"}].


render(cref, Dest, App, Mod, Xml, Version, Src) ->
    render(erlref, Dest, App, Mod, Xml, Version, Src);

render(erlref, Dest, App, Mod, Xml, Version, Src) ->
    
    File = filename:join([Dest, App, Mod++".html"]),
    ok   = filelib:ensure_dir(filename:dirname(File)++"/"),
    
    {_Acc, NXml} = render(fun tr_erlref/2, Xml, [{ids,[]}, {list, ul}]),

    Args = [{base, "../"},
            {title, Mod++" - "++Version},
            {content, xml_to_str(NXml)}],
    
    ok = file:write_file(File, file_tpl(Src, Args)).

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
    [ erlref, cref ].

get_funs(_App, _Mod, false) ->
    [];
get_funs(App, Mod, {funcs, [], Funs}) ->
    lists:foldl(
            fun(X, Acc) -> fun_stuff(App, Mod, X) ++ Acc end,
            [], Funs).

fun_stuff(App, Mod, {func, [], Child}) ->
    
    {fsummary, [], Xml} = lists:keyfind(fsummary, 1, Child),
    Summary = string:substr(xml_to_str(Xml), 1, 50),
    
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
            Name3          = lists:last(string:tokens(Name2, ":")),
            Args           = string:substr(Rest2, 2, string:chr(Rest2, 41)-2),
            NArgs          = length(string:tokens(Args, ",")),
            Name3 ++ "/" ++ integer_to_list(NArgs)
    end.

find_docs(OtpSrc) ->
    
    Docs = [ filelib:wildcard(Src ++ "/doc/src/*.xml")
             || Src <- filelib:wildcard(OtpSrc++"/lib/*/"),
                filelib:is_dir(Src) ],

    Erts = filelib:wildcard(OtpSrc ++ "/erts/doc/src/*.xml"),

    lists:foldl(fun lists:append/2, [], Docs) ++ Erts.

add_html("#"++Rest) ->
    "#"++Rest;
add_html(Link) ->
    case string:tokens(Link, "#") of
        [Tmp]    -> Tmp++".html";
        [N1, N2] -> lists:flatten([N1, ".html#", N2])
    end.     

%% Transforms erlang xml format to html
tr_erlref({header,[],_Child}, _Acc) ->
    ignore;
tr_erlref({marker, [{id, Marker}], []}, _Acc) ->
    {span, [{id, Marker}], [" "]};
tr_erlref({term,[{id, Term}], _Child}, _Acc) ->
    Term;
tr_erlref({lib,[],Lib}, _Acc) ->
    {h1, [], [lists:flatten(Lib)]};
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
    {'div', [{class,"functions"}], [{h4, [], ["Functions"]},
                                    {hr, [], []} | Child]};
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


%% Strips xml children that are entirely whitespace (space, tabs, newlines)
strip_whitespace(List) when is_list(List) ->
    [ strip_whitespace(X) || X <- List, is_whitespace(X) ]; 
strip_whitespace({El,Attr,Children}) ->
    {El, Attr, strip_whitespace(Children)};
strip_whitespace(Else) ->
    Else.

is_whitespace(X) when is_tuple(X); is_number(X) ->
    true;
is_whitespace(X) ->
    nomatch == re:run(X, "^[ \n\t]*$"). %"

%% rather basic xml to string converter, takes xml of the form
%% {tag, [{listof, "attributes"}], ["list of children"]}
%% into <tag listof="attributes">list of children</tag>
xml_to_str(Xml) ->
    xml_to_html(Xml).

xml_to_html({Tag, Attr, []}) ->
    fmt("<~s ~s />", [Tag, atos(Attr)]);
xml_to_html({Tag, [], []}) ->
    fmt("<~s />", [Tag]);
xml_to_html({Tag, [], Child}) ->
    fmt("<~s>~s</~s>", [Tag, xml_to_html(Child), Tag]);
xml_to_html({Tag, Attr, Child}) ->
    fmt("<~s ~s>~s</~s>", [Tag, atos(Attr), xml_to_html(Child), Tag]);
xml_to_html(List) when is_list(List) ->
    case io_lib:char_list(List) of
        true  -> htmlchars(List);
        false -> lists:flatten([ xml_to_html(X) || X <- List])
    end.

atos([])                      -> "";
atos(List) when is_list(List) -> string:join([ atos(X) || X <- List ], " ");
atos({Name, Val})             -> atom_to_list(Name) ++ "=\""++Val++"\"".

%% convert ascii into html characters
htmlchars(List) ->
    htmlchars(List, []).

htmlchars([], Acc) ->
    lists:flatten(lists:reverse(Acc));

htmlchars([$<   | Rest], Acc) -> htmlchars(Rest, ["&lt;" | Acc]);
htmlchars([$>   | Rest], Acc) -> htmlchars(Rest, ["&gt;" | Acc]);
htmlchars([160  | Rest], Acc) -> htmlchars(Rest, ["&nbsp;" | Acc]);
htmlchars([Else | Rest], Acc) -> htmlchars(Rest, [Else | Acc]).


% Read an xml file, need to cd into the xml directory because files
% are addressed relative to it
read_xml(OtpSrc, XmlFile) ->
    
    {ok, Pwd} = file:get_cwd(),
    file:set_cwd(filename:dirname(XmlFile)),
    
    Opts  = [{fetch_path, [OtpSrc++"/lib/docbuilder/dtd/"]},
             {encoding,   "latin1"}],
    try 
        {ok, Bin}    = file:read_file(XmlFile),
        {Xml, _Rest} = xmerl_scan:string(binary_to_list(Bin), Opts),
        file:set_cwd(Pwd),    
        xmerl_lib:simplify_element(Xml)
    catch
        _:Err ->
            file:set_cwd(Pwd),
            exit({error, XmlFile, Err})
    end.


%% Quick and dirty templating functions (replaces #KEY# in html with
%% {key, "Some text"}
file_tpl(Src, Args) ->
    {ok, Bin} = file:read_file([Src,"/","erldocs.tpl"]),
    str_tpl(Bin, Args).
    
str_tpl(Str, Args) ->
    F = fun({Key, Value}, Tpl) ->
                Opts = [{return, list}, global],
                NKey = "#"++string:to_upper(atom_to_list(Key))++"#",
                re:replace(Tpl, NKey, Value, Opts)
        end,
    lists:foldl(F, Str, Args).

%% lazy shorthand
fmt(Format, Args) ->
    lists:flatten(io_lib:format(Format, Args)).
