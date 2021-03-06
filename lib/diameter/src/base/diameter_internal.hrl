%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2010-2011. All Rights Reserved.
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

%% Our Erlang application.
-define(APPLICATION, diameter).

%% The one and only.
-define(DIAMETER_VERSION, 1).

%% Exception for use within a module with decent protection against
%% catching something we haven't thrown. Not foolproof but close
%% enough. ?MODULE is rudmentary protection against catching across
%% module boundaries, a root of much evil: always catch ?FAILURE(X),
%% never X.
-define(FAILURE(Reason), {{?MODULE}, {Reason}}).
-define(THROW(Reason),   throw(?FAILURE(Reason))).

%% A corresponding error when failure is the best option.
-define(ERROR(T), erlang:error({T, ?MODULE, ?LINE})).

%% Failure reports always get a stack trace.
-define(STACK, erlang:get_stacktrace()).

%% Warning report for unexpected messages in various processes.
-define(UNEXPECTED(F,A),
        diameter_lib:warning_report(unexpected, {?MODULE, F, A})).
-define(UNEXPECTED(A), ?UNEXPECTED(?FUNC, A)).

%% Something to trace on.
-define(LOG(Slogan, Details),
	diameter_lib:log(Slogan, ?MODULE, ?LINE, Details)).
-define(LOGC(Bool, Slogan, Details), ((Bool) andalso ?LOG(Slogan, Details))).

%% Compensate for no builtin ?FUNC for use in log reports.
-define(FUNC, element(2, element(2, process_info(self(), current_function)))).

%% Disjunctive match spec condition. 'false' is to ensure that there's at
%% least one condition.
-define(ORCOND(List), list_to_tuple(['orelse', false | List])).

%% 3588, 2.4:
-define(APP_ID_COMMON, 0).
-define(APP_ID_RELAY, 16#FFFFFFFF).

-define(BASE, diameter_gen_base_rfc3588).

%%% ---------------------------------------------------------

%%% RFC 3588, ch 2.6 Peer table
-record(diameter_peer,
        {host_id,
         statusT,
         is_dynamic,
         expiration,
         tls_enabled}).

%%% RFC 3588, ch 2.7 Realm-based routing table
-record(diameter_realm,
        {name,
         app_id,
         local_action, % LOCAL | RELAY | PROXY | REDIRECT
         server_id,
         is_dynamic,
         expiration}).
