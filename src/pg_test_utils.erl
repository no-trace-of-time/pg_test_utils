-module(pg_test_utils).

%% API exports
-export([
  new/1
  , name/1
]).

-define(TEST_REPO, pg_test_utils_t_repo).
-define(TEST_REPO_TBL, mchants).
-define(TEST_MODEL, pg_test_utils_t_model).
-define(TEST_PROTOCOL, pg_test_utils_t_protocol_up_resp_pay).

%%====================================================================
%% API functions
%%====================================================================
new(repo) ->
  pg_model:new(?TEST_REPO, #{id=>1, mcht_full_name=><<"full">>, mcht_short_name=><<"short">>, update_ts=>100});
new(model) ->
  pg_model:new(?TEST_MODEL, #{id=>1, mcht_full_name=><<"full">>, mcht_short_name=><<"short">>, update_ts=>100}).


name(repo) ->
  ?TEST_REPO;
name(model) ->
  ?TEST_MODEL;
name(table) ->
  ?TEST_REPO_TBL;
name(protocol) ->
  ?TEST_PROTOCOL.

%%====================================================================
%% Internal functions
%%====================================================================
