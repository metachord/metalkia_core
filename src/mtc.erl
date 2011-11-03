-module(mtc).

-export([
  get_env/1,
  get_env/2
]).

get_env(Param) ->
  get_env(Param, undefined).

get_env(Param, Default) ->
  case application:get_env(app(), Param) of
    {ok, Value} ->
      Value;
    undefined ->
      Default
  end.

%%
app() ->
  {ok, App} = application:get_application(?MODULE),
  App.
