%% 
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 1996-2009. All Rights Reserved.
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
-module(os_mon).

-behaviour(application).
-behaviour(supervisor).

%% API
-export([call/2, call/3, get_env/2]).

%% Application callbacks
-export([start/2, stop/1]).

%% Supervisor callbacks
-export([init/1]).

%%%-----------------------------------------------------------------
%%% API
%%%-----------------------------------------------------------------

call(Service, Request) ->
    call(Service, Request, 5000).

call(Service, Request, Timeout) ->
    try gen_server:call(server_name(Service), Request, Timeout)
    catch
	exit:{noproc, Call} ->
	    case lists:keysearch(os_mon, 1,
				 application:which_applications()) of
		{value, _AppInfo} ->
		    case startp(Service) of
			true ->
			    erlang:exit({noproc, Call});
			false ->
			    String = "OS_MON (~p) called by ~p, "
				     "unavailable~n",
			    error_logger:warning_msg(String,
						     [Service, self()]),
			    Service:dummy_reply(Request)
		    end;
		false ->
		    String = "OS_MON (~p) called by ~p, not started~n",
		    error_logger:warning_msg(String, [Service, self()]),
		    Service:dummy_reply(Request)
	    end
    end.

get_env(Service, Param) ->
    case application:get_env(os_mon, Param) of
	{ok, Value} ->
	    case Service:param_type(Param, Value) of
		true ->
		    Value;
		false ->
		    String = "OS_MON (~p), ignoring "
			     "bad configuration parameter (~p=~p)~n"
	                     "Using default value instead~n",
		    error_logger:warning_msg(String,
					     [Service, Param, Value]),
		    Service:param_default(Param)
	    end;
	undefined ->
	    Service:param_default(Param)
    end.

%%%-----------------------------------------------------------------
%%% Application callbacks
%%%-----------------------------------------------------------------

start(_, _) ->
    supervisor:start_link({local, os_mon_sup}, os_mon, []).

stop(_) ->
    ok.

%%%-----------------------------------------------------------------
%%% Supervisor callbacks
%%%-----------------------------------------------------------------

init([]) ->
    SupFlags = case os:type() of
		   {win32, _} ->
		       {one_for_one, 5, 3600};
		   _ ->
		       {one_for_one, 4, 3600}
	       end,
    SysInf = childspec(sysinfo, startp(sysinfo)),
    DskSup = childspec(disksup, startp(disksup)),
    MemSup = childspec(memsup,  startp(memsup)),
    CpuSup = childspec(cpu_sup, startp(cpu_sup)),
    OsSup  = childspec(os_sup,  startp(os_sup)),
    {ok, {SupFlags, SysInf ++ DskSup ++ MemSup ++ CpuSup ++ OsSup}}.

childspec(_Service, false) ->
    [];
childspec(cpu_sup, true) ->
    [{cpu_sup, {cpu_sup, start_link, []},
      permanent, 2000, worker, [cpu_sup]}];
childspec(disksup, true) ->
    [{disksup, {disksup, start_link, []},
      permanent, 2000, worker, [disksup]}];
childspec(memsup, true) ->
    [{memsup, {memsup, start_link, []},
      permanent, 2000, worker, [memsup]}];
childspec(os_sup, true) ->
    OS = os:type(),
    Mod = case OS of
	      {win32, _} -> nteventlog; % windows
	      _ -> os_sup % solaris
	  end,
    [{os_sup, {os_sup, start_link, [OS]},
      permanent, 10000, worker, [Mod]}];
childspec(sysinfo, true) ->
    [{os_mon_sysinfo, {os_mon_sysinfo, start_link, []},
      permanent, 2000, worker, [os_mon_sysinfo]}].

%%%-----------------------------------------------------------------
%%% Internal functions (OS_Mon configuration)
%%%-----------------------------------------------------------------

startp(Service) ->
    %% Available for this platform?
    case lists:member(Service, services(os:type())) of
	true ->
	    %% Is there a start configuration parameter?
	    case start_param(Service) of
		none ->
		    true;
		Param ->
		    %% Is the start configuration parameter 'true'?
		    case application:get_env(os_mon, Param) of
			{ok, true} ->
			    true;
			_ ->
			    false
		    end
	    end;
	false ->
	    false
    end.

services({unix, sunos}) ->
    [cpu_sup, disksup, memsup, os_sup];
services({unix, _}) -> % Other unix.
    [cpu_sup, disksup, memsup];
services({win32, _}) ->
    [disksup, memsup, os_sup, sysinfo];
services(vxworks) ->
    [memsup];
services(_) ->
    [].

server_name(cpu_sup) -> cpu_sup;
server_name(disksup) -> disksup;
server_name(memsup) ->  memsup;
server_name(os_sup) ->  os_sup_server;
server_name(sysinfo) -> os_mon_sysinfo.

start_param(cpu_sup) -> start_cpu_sup;
start_param(disksup) -> start_disksup;
start_param(memsup) ->  start_memsup;
start_param(os_sup) ->  start_os_sup;
start_param(sysinfo) -> none.
