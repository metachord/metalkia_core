-module(mtc_util).

-export([
         a2b/1,
         a2l/1
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
