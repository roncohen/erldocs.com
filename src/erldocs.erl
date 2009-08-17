-module(erldocs).

-export([build/0, build/2, index/0 ]).

-define(OTP_SRC, "erlsrc/otp_src_R13B").

% List of the type of xml files erldocs can build
buildable() ->
    [ erlref ].

% bleh I hate doing this
root() ->
    {ok, Path} = file:get_cwd(),
    ["src" | Rest] = lists:reverse(string:tokens(Path, "/")),
    "/"++string:join(lists:reverse(Rest), "/").

% Build the documentation
build() ->
    build(root() ++ "/" ++ ?OTP_SRC).
build(Src) -> 
    ok = build(Src, find_docs(Src)).

build(_Otp, []) ->
    ok;
build(Otp, [ DocSrc | Rest]) ->

    [File, "src", "doc", App | Path]
        = lists:reverse(string:tokens(DocSrc, "/")),
    
    Root = string:join(lists:reverse(Path), "/")++"/"++App++"/doc/src",

    file:set_cwd(Root),

    Opts = [ {encoding, "latin1"}, {fetch_path, [Otp++"/lib/docbuilder/dtd/"]}],
    {Type, _Attr, Content} = simplexml_read_file(DocSrc, Opts),
        
    case lists:member(Type, buildable()) of
	false -> ok;
	true  ->
	    OutDir = root()++"/www/"++App++"/",
	    ok = filelib:ensure_dir(OutDir),
	    Mod = filename:basename(File, ".xml"),
	    render(Type, App, Mod, Content)
    end,
    
    file:set_cwd(root()++"/src"),
    
    build(Otp, Rest).

render(erlref, App, Mod, Xml) ->
    Html = erlref_wrap(Mod, render(fun tr_erlref/1, Xml)),
    File = root()++"/www/"++App++"/"++Mod++".html",
    HtmlStr = lists:flatten(xmerl:export_simple(Html, xmerl_xml,
                                                [{prolog,"<!DOCTYPE html>"}])),
    file:write_file(File, HtmlStr).

render(Fun, List) when is_list(List) ->
    case io_lib:char_list(List) of 
	true ->
	    List;
	false ->
	    [ render(Fun, X) || X <- List ]
    end;
render(Fun, Element) ->
    case Fun(Element) of
        ignore               -> "";
        {stop, Result}       -> Result;
        {NEl, NAttr, NChild} -> {NEl, NAttr, render(Fun, NChild)};
        Else                 -> Else
    end.

index() ->
    index(root() ++ "/" ++ ?OTP_SRC).
index(Src) ->
    Sort = fun(["app" | _Rest1], ["mod" | _Rest2]) -> true;
	      (["app" | _Rest1], ["fun" | _Rest2]) -> true;
	      (["mod" | _Rest1], ["fun" | _Rest2]) -> true;
	      (_, _) -> false
	   end,

    Index = lists:sort(Sort, index(Src, find_docs(Src), [])),
    
    Str = lists:flatten(io_lib:format("~p",[Index])),
    Js  = lists:flatten(io_lib:format("var index = ~s;",[Str])),
    file:write_file(root()++"/www/erldocs_index.js", Js), 
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
    file:set_cwd(root()++"/src"),
    
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
            % strip silly shy characters
            Mod  = [ X || X <- string:join(Module, ""), X =/= 173],
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
                 
to_string(Xml) ->
    lists:flatten(xmerl:export_simple(Xml, xmerl_xml, [{prolog,[]}])).

strip_whitespace(List) when is_list(List) ->
    [ strip_whitespace(X) || X <- List, X =/= " "];
strip_whitespace({El,Attr,Children}) ->
    {El, Attr, strip_whitespace(Children)};
strip_whitespace(Else) ->
    Else.
    
find_docs(Otp) ->
    Docs = [ filelib:wildcard(Src ++ "/doc/src/*.xml")
             || Src <- filelib:wildcard(Otp++"/lib/*/"),
                filelib:is_dir(Src) ],
 
    lists:foldl(fun lists:append/2, [], Docs).

simplexml_read_string(Str, Opts) ->
    {XML,_Rest} = xmerl_scan:string(Str, Opts),
    xmerl_lib:simplify_element(XML).

simplexml_read_file(File, Opts) ->
    {ok, Bin} = file:read_file(File),
    simplexml_read_string(binary_to_list(Bin), Opts).

% eugh: template to wrap pages in
erlref_wrap(Module, Xml) ->
    [{html, [{lang, "en"}], [        
       {head, [], [
         {meta,  [{charset, "utf-8"}], []},
         {title, [], [Module ++ " - erldocs.com"]},
         {link,  [{type, "text/css"}, {rel, "stylesheet"},
                  {href, "../erldocs.css"}], []}
       ]},
       {body, [], [
         {'div', [{id, "sidebar"}], [
           {input, [{type, "text"}, {value,"Search"}, {id, "search"},
                    {autocomplete, "off"}], []},
           {ul, [{id, "results"}], [" "]},
	   {'div', [{class, "copystuff"}], [
             {span, [], [" © Ericsson, "]},
	     {a, [{target, "blank"}, {href, "http://github.com/daleharvey/erldocs.com/tree"}], ["Source (github)"]}
           ]}		     
         ]},
         {'div', [{id, "content"}], Xml},
         {script, [{src, "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.js"}], [" "]},
         {script, [{src, "../erldocs_index.js"}], [" "]},
         {script, [{src, "../erldocs.js"}], [" "]}
       ]}
     ]}].

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
    {p, [{class, "description"}], Child};
tr_erlref({description, [], Child}) ->
    {p, [{class, "description"}], Child};
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
    {h3, [], [{a, [{name, Name}], [Child]}]};
tr_erlref({fsummary, [], _Child}) ->
    ignore;
tr_erlref(Else) ->
    Else.


htmlize(List) when is_list(List) ->
    htmlize_l(List);
htmlize(Else) ->
    Else.

htmlize_l(List) ->    
    htmlize_l(List, []).
 
htmlize_l([], Acc) ->
     lists:reverse(Acc);
htmlize_l([$>|Tail], Acc) ->
    htmlize_l(Tail, [$;,$t,$g,$&|Acc]);
htmlize_l([$<|Tail], Acc) ->
    htmlize_l(Tail, [$;,$t,$l,$&|Acc]);
htmlize_l([$&|Tail], Acc) ->
    htmlize_l(Tail, [$;,$p,$m,$a,$&|Acc]);
htmlize_l([$"|Tail], Acc) ->
    htmlize_l(Tail, [$; , $t, $o, $u, $q ,$&|Acc]);
htmlize_l([160|Tail], Acc) ->
    htmlize_l(Tail, [10|Acc]);
           
htmlize_l([X|Tail], Acc) when is_integer(X) ->
    htmlize_l(Tail, [X|Acc]);
htmlize_l([X|Tail], Acc) when is_binary(X) ->
    X2 = htmlize_l(binary_to_list(X)),
    htmlize_l(Tail, [X2|Acc]);
htmlize_l([X|Tail], Ack) when is_list(X) ->
    X2 = htmlize_l(X),
    htmlize_l(Tail, [X2|Ack]).
