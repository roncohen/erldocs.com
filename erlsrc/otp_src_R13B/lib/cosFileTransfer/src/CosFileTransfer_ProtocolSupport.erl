%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: CosFileTransfer_ProtocolSupport
%% Source: /net/shelob/ldisk/daily_build/otp_prebuild_r13b.2009-04-20_20/otp_src_R13B/lib/cosFileTransfer/src/CosFileTransfer.idl
%% IC vsn: 4.2.20
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module('CosFileTransfer_ProtocolSupport').
-ic_compiled("4_2_20").


-include("CosFileTransfer.hrl").

-export([tc/0,id/0,name/0]).



%% returns type code
tc() -> {tk_struct,"IDL:omg.org/CosFileTransfer/ProtocolSupport:1.0",
                   "ProtocolSupport",
                   [{"protocol_name",{tk_string,0}},
                    {"addresses",{tk_sequence,{tk_string,0},0}}]}.

%% returns id
id() -> "IDL:omg.org/CosFileTransfer/ProtocolSupport:1.0".

%% returns name
name() -> "CosFileTransfer_ProtocolSupport".


