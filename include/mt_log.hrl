-ifndef(MT_LOG_H).
-define(MT_LOG_H, true).

-define(DBG(F, A), io:format("(~w:~b) ~p " ++ F ++ "~n", [?MODULE, ?LINE, self() | A])).

-endif. % MT_LOG_H
