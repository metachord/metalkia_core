-ifndef(MT_LOG_H).
-define(MT_LOG_H, true).

-define(DBG(F, A), io:format("(~w:~b) " ++ F ++ "~n", [?MODULE, ?LINE | A])).

-endif. % MT_LOG_H
