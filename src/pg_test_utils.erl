-module(pg_test_utils).

%% API exports
-export([
  new/1
  , name/1
  , setup/1
]).

-export([
  env_init/1
  , db_init/1
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

%%--------------------------------------------------------------------
name(repo) ->
  ?TEST_REPO;
name(model) ->
  ?TEST_MODEL;
name(table) ->
  ?TEST_REPO_TBL;
name(protocol) ->
  ?TEST_PROTOCOL.

%%--------------------------------------------------------------------
setup(mnesia) ->
  Dir = "/tmp/mnesia_test",
  os:cmd("mkdir " ++ Dir),
  application:set_env(mnesia, dir, Dir),
  mnesia:stop(),
  mnesia:delete_schema([node()]),
  mnesia:create_schema([node()]),

  ok = application:start(mnesia),
  ok.


%%---------------------------------------------------------------------
-spec env_init(Cfgs :: proplists:proplist()) -> ok.

env_init(Cfgs) when is_list(Cfgs) ->
  F =
    fun(App, CfgList) ->
      [application:set_env(App, Key, Val) || {Key, Val} <- CfgList]
    end,

  [F(App, CfgList) || {App, CfgList} <- Cfgs],

  ok.
%%---------------------------------------------------------------------
-spec db_init(Cfgs :: proplists:proplist()) -> ok.

db_init(Cfgs) when is_list(Cfgs) ->
  F =
    fun(M, ValueList) ->
      pg_repo:drop(M),
      pg_repo:init(M),
      [db_init_one_row(M, VL) || VL <- ValueList]
    end,

  [F(M, DataList) || {M, DataList} <- Cfgs],

  ok.

db_init_one_row(M, VL) ->
  Repo = pg_model:new(M, VL),
  pg_repo:save(Repo).
%%====================================================================
%% Internal functions
%%====================================================================
