%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 1998-2009. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%%

%%%-------------------------------------------------------------------
%%% Purpose: Test server support functions.
%%%-------------------------------------------------------------------
-module(test_server_sup).
-export([timetrap/2, timetrap_cancel/1, capture_get/1, messages_get/1,
	 timecall/3, call_crash/5, app_test/2, check_new_crash_dumps/0,
	 cleanup_crash_dumps/0, crash_dump_dir/0, tar_crash_dumps/0,
	 get_username/0, get_os_family/0, 
	 hostatom/0, hostatom/1, hoststr/0, hoststr/1,
	 framework_call/2,framework_call/3,
	 format_loc/1, package_str/1, package_atom/1,
	 call_trace/1]).
-include("test_server_internal.hrl").
-define(crash_dump_tar,"crash_dumps.tar.gz").
-define(src_listing_ext, ".src.html").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% timetrap(Timeout,Pid) -> Handle
%% Handle = term()
%%
%% Creates a time trap, that will kill the given process if the 
%% trap is not cancelled with timetrap_cancel/1, within Timeout
%% milliseconds.

timetrap(Timeout0, Pid) ->
    process_flag(priority, max),
    Timeout = test_server:timetrap_scale_factor() * Timeout0,
    receive
    after trunc(Timeout) ->
	    Line = test_server:get_loc(Pid),
	    Mon = erlang:monitor(process, Pid),
	    Trap = {timetrap_timeout, trunc(Timeout), Line},
	    exit(Pid,Trap),
	    receive
		{'DOWN', Mon, process, Pid, _} ->
		    ok
	    after 10000 ->
		    %% Pid is probably trapping exits, hit it harder...
		    catch error_logger:warning_msg("Testcase process ~p not "
						   "responding to timetrap "
						   "timeout:~n"
						   "  ~p.~n"
						   "Killing testcase...~n",
						   [Pid, Trap]),
		    exit(Pid, kill)
	    end
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% timetrap_cancel(Handle) -> ok
%% Handle = term()
%%
%% Cancels a time trap.

timetrap_cancel(Handle) ->
    unlink(Handle),
    MonRef = erlang:monitor(process, Handle),
    exit(Handle, kill),
    receive {'DOWN',MonRef,_,_,_} -> ok after 2000 -> ok end.

capture_get(Msgs) ->
    receive
	{captured,Msg} ->
	    capture_get([Msg|Msgs])
    after 0 ->
	    lists:reverse(Msgs)
    end.


messages_get(Msgs) ->
    receive
	Msg ->
	    messages_get([Msg|Msgs])
    after 0 ->
	    lists:reverse(Msgs)
    end.


timecall(M, F, A) ->
    Befor = erlang:now(),
    Val = apply(M, F, A),
    After = erlang:now(),
    Elapsed =
        (element(1,After)*1000000+element(2,After)+element(3,After)/1000000)-
        (element(1,Befor)*1000000+element(2,Befor)+element(3,Befor)/1000000),
    {Elapsed, Val}.



call_crash(Time,Crash,M,F,A) ->
    OldTrapExit = process_flag(trap_exit,true),
    Pid = spawn_link(M,F,A),
    Answer =
	receive
	    {'EXIT',Crash} ->
		ok;
	    {'EXIT',Pid,Crash} ->
		ok;
	    {'EXIT',_Reason} when Crash==any ->
		ok;
	    {'EXIT',Pid,_Reason} when Crash==any ->
		ok;
	    {'EXIT',Reason} ->
		test_server:format(12, "Wrong crash reason. Wanted ~p, got ~p.",
		      [Crash, Reason]),
		exit({wrong_crash_reason,Reason});
	    {'EXIT',Pid,Reason} ->
		test_server:format(12, "Wrong crash reason. Wanted ~p, got ~p.",
		      [Crash, Reason]),
		exit({wrong_crash_reason,Reason});
	    {'EXIT',OtherPid,Reason} when OldTrapExit == false ->
		exit({'EXIT',OtherPid,Reason})
	after do_trunc(Time) ->
		exit(call_crash_timeout)
	end,
    process_flag(trap_exit,OldTrapExit),
    Answer.

do_trunc(infinity) -> infinity;
do_trunc(T) -> trunc(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% app_test/2
%%
%% Checks one applications .app file for obvious errors.
%% Checks..
%% * .. required fields
%% * .. that all modules specified actually exists
%% * .. that all requires applications exists
%% * .. that no module included in the application has export_all
%% * .. that all modules in the ebin/ dir is included
%%      (This only produce a warning, as all modules does not
%%       have to be included (If the `pedantic' option isn't used))
app_test(Application, Mode) ->
    case is_app(Application) of
	{ok, AppFile} ->
	    do_app_tests(AppFile, Application, Mode);
	Error ->
	    test_server:fail(Error)
    end.

is_app(Application) ->
    case file:consult(filename:join([code:lib_dir(Application),"ebin",
		   atom_to_list(Application)++".app"])) of
	{ok, [{application, Application, AppFile}] } ->
	    {ok, AppFile};
	_ ->
	    test_server:format(minor,
			       "Application (.app) file not found, "
			       "or it has very bad syntax.~n"),
	    {error, not_an_application}
    end.


do_app_tests(AppFile, AppName, Mode) ->
    DictList=
	[
	 {missing_fields, []},
	 {missing_mods, []},
	 {superfluous_mods_in_ebin, []},
	 {export_all_mods, []},
	 {missing_apps, []}
	],
    fill_dictionary(DictList),

    %% An appfile must (?) have some fields..
    check_fields([description, modules, registered, applications], AppFile),

    %% Check for missing and extra modules.
    {value, {modules, Mods}}=lists:keysearch(modules, 1, AppFile),
    EBinList=lists:sort(get_ebin_modnames(AppName)),
    {Missing, Extra} = common(lists:sort(Mods), EBinList),
    put(superfluous_mods_in_ebin, Extra),
    put(missing_mods, Missing),

    %% Check that no modules in the application has export_all.
    app_check_export_all(Mods),

    %% Check that all specified applications exists.
    {value, {applications, Apps}}=
	lists:keysearch(applications, 1, AppFile),
    check_apps(Apps),

    A=check_dict(missing_fields, "Inconsistent app file, "
	       "missing fields"),
    B=check_dict(missing_mods, "Inconsistent app file, "
	       "missing modules"),
    C=check_dict_tolerant(superfluous_mods_in_ebin, "Inconsistent app file, "
	       "Modules not included in app file.", Mode),
    D=check_dict(export_all_mods, "Inconsistent app file, "
	       "Modules have `export_all'."),
    E=check_dict(missing_apps, "Inconsistent app file, "
	       "missing applications."),

    erase_dictionary(DictList),
    case A+B+C+D+E of
	5 ->
	    ok;
	_ ->
	    test_server:fail()
    end.

app_check_export_all([]) ->
    ok;
app_check_export_all([Mod|Mods]) ->
    case catch apply(Mod, module_info, [compile]) of
	{'EXIT', {undef,_}} ->
	    app_check_export_all(Mods);
	COpts ->
	    case lists:keysearch(options, 1, COpts) of
		false ->
		    app_check_export_all(Mods);
		{value, {options, List}} ->
		    case lists:member(export_all, List) of
			true ->
			    put(export_all_mods, [Mod|get(export_all_mods)]),
			    app_check_export_all(Mods);
			false ->
			    app_check_export_all(Mods)
		    end
	    end
    end.

%% Given two sorted lists, L1 and L2, returns {NotInL2, NotInL1},
%% NotInL2 is the elements of L1 which don't occurr in L2,
%% NotInL1 is the elements of L2 which don't ocurr in L1.

common(L1, L2) ->
    common(L1, L2, [], []).

common([X|Rest1], [X|Rest2], A1, A2) ->
    common(Rest1, Rest2, A1, A2);
common([X|Rest1], [Y|Rest2], A1, A2) when X < Y ->
    common(Rest1, [Y|Rest2], [X|A1], A2);
common([X|Rest1], [Y|Rest2], A1, A2) ->
    common([X|Rest1], Rest2, A1, [Y|A2]);
common([], L, A1, A2) ->
    {A1, L++A2};
common(L, [], A1, A2) ->
    {L++A1, A2}.

check_apps([]) ->
    ok;
check_apps([App|Apps]) ->
    case is_app(App) of
	{ok, _AppFile} ->
	    ok;
	{error, _} ->
	    put(missing_apps, [App|get(missing_apps)])
    end,
    check_apps(Apps).

check_fields([], _AppFile) ->
    ok;
check_fields([L|Ls], AppFile) ->
    check_field(L, AppFile),
    check_fields(Ls, AppFile).

check_field(FieldName, AppFile) ->
    case lists:keymember(FieldName, 1, AppFile) of
	true ->
	    ok;
	false ->
	    put(missing_fields, [FieldName|get(missing_fields)]),
	    ok
    end.

check_dict(Dict, Reason) ->
    case get(Dict) of
	[] ->
	    1;                         % All ok.
	List ->
	    io:format("** ~s (~s) ->~n~p~n",[Reason, Dict, List]),
	    0
    end.

check_dict_tolerant(Dict, Reason, Mode) ->
    case get(Dict) of
	[] ->
	    1;                         % All ok.
	List ->
	    io:format("** ~s (~s) ->~n~p~n",[Reason, Dict, List]),
	    case Mode of
		pedantic ->
		    0;
		_ ->
		    1
	    end
    end.

get_ebin_modnames(AppName) ->
    Wc=filename:join([code:lib_dir(AppName),"ebin",
		      "*"++code:objfile_extension()]),
    TheFun=fun(X, Acc) ->
		   [list_to_atom(filename:rootname(
				   filename:basename(X)))|Acc] end,
    _Files=lists:foldl(TheFun, [], filelib:wildcard(Wc)).

%%
%% This function removes any erl_crash_dump* files found in the
%% test server directory. Done only once when the test server
%% is started.
%%
cleanup_crash_dumps() ->
    Dir = crash_dump_dir(),
    Dumps = filelib:wildcard(filename:join(Dir, "erl_crash_dump*")),
    delete_files(Dumps).

crash_dump_dir() ->
    filename:dirname(code:which(?MODULE)).

tar_crash_dumps() ->
    Dir = crash_dump_dir(),
    case filelib:wildcard(filename:join(Dir, "erl_crash_dump*")) of
	[] -> {error,no_crash_dumps};
	Dumps ->
	    TarFileName = filename:join(Dir,?crash_dump_tar),
	    {ok,Tar} = erl_tar:open(TarFileName,[write,compressed]),
	    lists:foreach(
	      fun(File) -> 
		      ok = erl_tar:add(Tar,File,filename:basename(File),[])
	      end,
	      Dumps),
	    ok = erl_tar:close(Tar),
	    delete_files(Dumps),
	    {ok,TarFileName}
    end.


check_new_crash_dumps() ->
    Dir = crash_dump_dir(),
    Dumps = filelib:wildcard(filename:join(Dir, "erl_crash_dump*")),
    case length(Dumps) of
	0 ->
	    ok;
	Num ->
	    test_server_ctrl:format(minor,
				    "Found ~p crash dumps:~n", [Num]),
	    append_files_to_logfile(Dumps),
	    delete_files(Dumps)
    end.

append_files_to_logfile([]) -> ok;
append_files_to_logfile([File|Files]) ->
    NodeName=from($., File),
    test_server_ctrl:format(minor, "Crash dump from node ~p:~n",[NodeName]),
    Fd=get(test_server_minor_fd),
    case file:read_file(File) of
	{ok, Bin} ->
	    case file:write(Fd, Bin) of
		ok ->
		    ok;
		{error,Error} ->
		    %% Write failed. The following io:format/3 will probably also
		    %% fail, but in that case it will throw an exception so that
		    %% we will be aware of the problem.
		    io:format(Fd, "Unable to write the crash dump "
			      "to this file: ~p~n", [file:format_error(Error)])
	    end;
	_Error ->
	    io:format(Fd, "Failed to read: ~s\n", [File])
    end,
    append_files_to_logfile(Files).

delete_files([]) -> ok;
delete_files([File|Files]) ->
    io:format("Deleting file: ~s~n", [File]),
    case file:delete(File) of
	{error, _} ->
	    case file:rename(File, File++".old") of
		{error, Error} ->
		    io:format("Could neither delete nor rename file "
			      "~s: ~s.~n", [File, Error]);
		_ ->
		    ok
	    end;
	_ ->
	    ok
    end,
    delete_files(Files).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% erase_dictionary(Vars) -> ok
%% Vars = [atom(),...]
%%
%% Takes a list of dictionary keys, KeyVals, erases
%% each key and returns ok.
erase_dictionary([{Var, _Val}|Vars]) ->
    erase(Var),
    erase_dictionary(Vars);
erase_dictionary([]) ->
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% fill_dictionary(KeyVals) -> void()
%% KeyVals = [{atom(),term()},...]
%%
%% Takes each Key-Value pair, and inserts it in the process dictionary.
fill_dictionary([{Var,Val}|Vars]) ->
    put(Var,Val),
    fill_dictionary(Vars);
fill_dictionary([]) ->
    [].



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get_username() -> UserName
%%
%% Returns the current user
get_username() ->
    getenv_any(["USER","USERNAME"]).
    
getenv_any([Key|Rest]) ->
    case catch os:getenv(Key) of
	String when is_list(String) -> String;
	false -> getenv_any(Rest)
    end;
getenv_any([]) -> "".


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get_os_family() -> OsFamily
%%
%% Returns the OS family
get_os_family() ->
    case os:type() of
	{OsFamily,_OsName} -> OsFamily;
	OsFamily -> OsFamily
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% hostatom()/hostatom(Node) -> Host; atom()
%% hoststr() | hoststr(Node) -> Host; string()
%%
%% Returns the OS family
hostatom() ->
    hostatom(node()).
hostatom(Node) ->
    list_to_atom(hoststr(Node)).
hoststr() ->
    hoststr(node()).
hoststr(Node) when is_atom(Node) ->
    hoststr(atom_to_list(Node));
hoststr(Node) when is_list(Node) ->
    from($@, Node).
    
from(H, [H | T]) -> T;
from(H, [_ | T]) -> from(H, T);
from(_H, []) -> [].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% framework_call(Callback,Func,Args,DefaultReturn) -> Retur | DefaultReturn
%% 
%% Calls the given Func in Callback
framework_call(Func,Args) ->
    framework_call(Func,Args,ok).
framework_call(Func,Args,DefaultReturn) ->
    CB = os:getenv("TEST_SERVER_FRAMEWORK"),
    framework_call(CB,Func,Args,DefaultReturn).
framework_call(false,_Func,_Args,DefaultReturn) ->
    DefaultReturn;
framework_call(Callback,Func,Args,DefaultReturn) ->
    Mod = list_to_atom(Callback),
    case code:is_loaded(Mod) of
	false -> code:load_file(Mod);
	_ -> ok
    end,
    case erlang:function_exported(Mod,Func,length(Args)) of
	true ->
	    apply(Mod,Func,Args);
	false ->
	    DefaultReturn
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% format_loc(Loc) -> string()
%% 
%% Formats the printout of the line of code read from 
%% process dictionary (test_server_loc). Adds link to 
%% correct line in source code.
format_loc([{Mod,Func,Line}]) ->
    [format_loc1({Mod,Func,Line})];
format_loc([{Mod,Func,Line}|Rest]) ->
    ["[",format_loc1({Mod,Func,Line}),",\n"|format_loc1(Rest)];
format_loc([{Mod,LineOrFunc}]) ->
    format_loc({Mod,LineOrFunc});
format_loc({Mod,Func}) when is_atom(Func) -> 
    io_lib:format("{~s,~w}",[package_str(Mod),Func]);
format_loc({Mod,Line}) when is_integer(Line) -> 
    %% ?line macro is used
    ModStr = package_str(Mod),
    case lists:reverse(ModStr) of
	[$E,$T,$I,$U,$S,$_|_]  ->
	    io_lib:format("{~s,<a href=\"~s~s#~w\">~w</a>}",
			  [ModStr,downcase(ModStr),?src_listing_ext,
			   round_to_10(Line),Line]);
	_ ->
	    io_lib:format("{~s,~w}",[ModStr,Line])
    end;
format_loc(Loc) ->
    io_lib:format("~p",[Loc]).    

format_loc1([{Mod,Func,Line}]) ->
    ["              ",format_loc1({Mod,Func,Line}),"]"];
format_loc1([{Mod,Func,Line}|Rest]) ->
    ["              ",format_loc1({Mod,Func,Line}),",\n"|format_loc1(Rest)];
format_loc1({Mod,Func,Line}) ->
    ModStr = package_str(Mod),
    case lists:reverse(ModStr) of
	[$E,$T,$I,$U,$S,$_|_]  ->
	    io_lib:format("{~s,~w,<a href=\"~s~s#~w\">~w</a>}",
			  [ModStr,Func,downcase(ModStr),?src_listing_ext,
			   round_to_10(Line),Line]);
	_ ->
	    io_lib:format("{~s,~w,~w}",[ModStr,Func,Line])
    end.

round_to_10(N) when (N rem 10) == 0 ->
    N;
round_to_10(N) ->
    trunc(N/10)*10.

downcase(S) -> downcase(S, []).
downcase([Uc|Rest], Result) when $A =< Uc, Uc =< $Z ->
    downcase(Rest, [Uc-$A+$a|Result]);
downcase([C|Rest], Result) ->
    downcase(Rest, [C|Result]);
downcase([], Result) ->
    lists:reverse(Result).

package_str(Mod) when is_atom(Mod) ->
    atom_to_list(Mod);
package_str(Mod) when is_list(Mod), is_atom(hd(Mod)) ->
    %% convert [s1,s2] -> "s1.s2"
    [_|M] = lists:flatten(["."++atom_to_list(S) || S <- Mod]),
    M;
package_str(Mod) when is_list(Mod) ->
    Mod.

package_atom(Mod) when is_atom(Mod) ->
    Mod;
package_atom(Mod) when is_list(Mod), is_atom(hd(Mod)) ->
    list_to_atom(package_str(Mod));
package_atom(Mod) when is_list(Mod) ->
    list_to_atom(Mod).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% call_trace(TraceSpecFile) -> ok
%%
%% Read terms on format {m,Mod} | {f,Mod,Func}
%% from TraceSpecFile and enable call trace for
%% specified functions.
call_trace(TraceSpec) ->
    case file:consult(TraceSpec) of
	{ok,Terms} ->
	    dbg:tracer(),
	    %% dbg:p(self(), [p, m, sos, call]),
	    dbg:p(self(), [sos, call]),
	    lists:foreach(fun({m,M}) ->
				  case dbg:tpl(M,[{'_',[],[{return_trace}]}]) of
				      {error,What} -> exit({error,{tracing_failed,What}});
				      _ -> ok
				  end;			  
			     ({f,M,F}) ->
				  case dbg:tpl(M,F,[{'_',[],[{return_trace}]}]) of
				      {error,What} -> exit({error,{tracing_failed,What}});
				      _ -> ok
				  end;			  
			     (Huh) ->
				  exit({error,{unrecognized_trace_term,Huh}})
			  end, Terms),
	    ok;
	{_,Error} ->
	    exit({error,{tracing_failed,TraceSpec,Error}})
    end.
    
