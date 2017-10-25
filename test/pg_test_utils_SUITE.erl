%%%-------------------------------------------------------------------
%%% @author simon
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 十月 2017 20:51
%%%-------------------------------------------------------------------
-module(pg_test_utils_SUITE).
-include_lib("eunit/include/eunit.hrl").
-author("simon").

%% API
-export([]).

setup() ->
  pg_test_utils:setup(mnesia),
  ok.

my_test_() ->
  {
    setup,
    fun setup/0,
    {
      inorder,
      [
        fun mnesia_test_1/0

      ]
    }
  }.

mnesia_test_1() ->
  ?assertEqual([nonode@nohost], mnesia:table_info(schema, disc_copies)),
  ok.
