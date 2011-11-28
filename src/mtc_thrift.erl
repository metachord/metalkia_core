-module(mtc_thrift).

-include_lib("thrift/include/thrift_constants.hrl").

-export([
         write/1,
         read/2
        ]).

write(S) ->
  {ok, T0} = thrift_memory_buffer:new(),
  {ok, P0} = thrift_binary_protocol:new(T0),
  StructName = element(1, S),
  {P1, ok} = thrift_protocol:write(P0,{{struct, {mtc_schema_types, StructName}}, S}),
  {_P2, Data} = thrift_protocol:flush_transport(P1),
  iolist_to_binary(Data).

read(StructName, Data) ->
  {ok, T0} = thrift_memory_buffer:new(Data),
  {ok, P0} = thrift_binary_protocol:new(T0),
  {_P2, {ok, S}} = thrift_protocol:read(P0,{struct, {mtc_schema_types, StructName}}),
  S.

