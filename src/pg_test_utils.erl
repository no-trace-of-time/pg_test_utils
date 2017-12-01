-module(pg_test_utils).

%% API exports
-export([
  setup/1
]).

-export([
  env_init/1
  , db_init/1
  , lager_init/0
  , http_echo_server_init/0
  , http_echo_server_init/1
]).

%%====================================================================
%% API functions
%%====================================================================
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
%%------------------------------------------------------------
lager_init() ->
  LagerHandlerCfg = [
    {lager_console_backend, [{level, debug}, {formatter, lager_default_formatter},
      {formatter_config, [
        date, " ", time
        , " [", severity, "]"
        , {module, [
          module,
          {function, [":", function], ""},
          {line, [":", line], ""}], ""},
        {pid, ["@", pid], ""},
        message
        , "\n"

      ]}]}
  ],
  application:set_env(lager, handlers, LagerHandlerCfg),
  lager:start().
%%------------------------------------------------------------
http_echo_server_init() ->
  http_echo_server_init(pg_test_utils_echo_server).

http_echo_server_init(M) when is_atom(M) ->
  Port = application:get_env(pg_test_utils, echo_server_port, 9999),
  {ok, _Pid} = inets:start(httpd, [
    {module, [mod_esi]},
    {port, Port},
    {server_name, "localhost"},
    {document_root, "."},
    {server_root, "."},
    {erl_script_alias, {"/esi", [M]}}
  ]).

%%====================================================================
%% Internal functions
%%====================================================================
