-module(mtc_util).

-include_lib("metalkia_core/include/mt_records.hrl").

-export([
         a2b/1,
         a2l/1,
         a2i/1,
         io2b/1,
         a2gender/1,
         timestamp/0,
         get_env/3,
         uri_encode/1,
         uri_decode/1,
         rand_str/1
        ]).


a2b(A) when is_atom(A) -> atom_to_binary(A, latin1);
a2b(A) when is_integer(A) -> list_to_binary(integer_to_list(A));
a2b(A) when is_list(A) -> list_to_binary(A);
a2b(A) when is_binary(A) -> A;
a2b(A) -> A.

a2l(A) when is_atom(A) -> atom_to_list(A);
a2l(A) when is_integer(A) -> integer_to_list(A);
a2l(A) when is_list(A) -> A;
a2l(A) when is_binary(A) -> binary_to_list(A);
a2l(A) -> A.

a2i(A) when is_integer(A) -> A;
a2i(A) when is_list(A) -> list_to_integer(A);
a2i(A) when is_binary(A) -> a2i(binary_to_list(A));
a2i(null) -> 0;
a2i(_) -> throw(badarg).

io2b(IoList) ->
  iolist_to_binary(IoList).

a2gender(A) ->
  case A of
    <<"male">> -> ?mtc_schema_Mt_gender_MALE;
    <<"female">> -> ?mtc_schema_Mt_gender_FEMALE;
    _ -> ?mtc_schema_Mt_gender_UNKNOWN
  end.

timestamp() ->
  {A1, A2, _} = now(),
  A1*1000*1000+A2.

get_env(ModPid, Param, Default) ->
  {ok, App} = application:get_application(ModPid),
  case application:get_env(App, Param) of
    {ok, Value} ->
      Value;
    undefined ->
      Default
  end.

uri_encode(URI) ->
  mochiweb_util:quote_plus(URI).

uri_decode(URI) ->
  mochiweb_util:unquote(URI).

rand_str(Size) ->
  Str = re:replace(crypto:rand_bytes(Size*12), "[^0-9a-zA-Z]", "", [global, {return, list}]),
  if length(Str) < Size ->
      rand_str(Size);
     true ->
      {Ret, _} = lists:split(Size, Str),
      Ret
  end.
