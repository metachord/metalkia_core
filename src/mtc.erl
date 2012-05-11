%%% @copyright  2012 Metachord Ltd.
%%% @author     Max Treskin <mtreskin@metachord.com>


-module(mtc).

-export([
  get_env/1,
  get_env/2,
  rl/0,
  rl/1
]).

get_env(Param) ->
  mtc_util:get_env(?MODULE, Param, undefined).

get_env(Param, Default) ->
  mtc_util:get_env(?MODULE, Param, Default).

rl() ->
  rl(?MODULE).

rl(AppModuleName) ->
  {ok, App} = application:get_application(AppModuleName),
  {ok, Keys} = application:get_all_key(App),
  Modules =
  case lists:keysearch(modules, 1, Keys) of
    {value, {modules, Mods}} -> Mods;
    _ -> []
  end,
  Reload = fun(Module) ->
    code:purge(Module),
    code:load_file(Module),
    io:format("reload ~p~n", [Module])
  end,
  [Reload(Mod) || Mod <- Modules],
  ok.
