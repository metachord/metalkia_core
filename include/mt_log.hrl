-ifndef(MT_LOG_H).
-define(MT_LOG_H, true).

-define(DBG(F, A), error_logger:info_msg("(~w:~b) ~p " ++ F ++ "~n", [?MODULE, ?LINE, self() | A])).
-define(WRN(F, A), error_logger:watning_msg("(~w:~b) ~p " ++ F ++ "~n", [?MODULE, ?LINE, self() | A])).
-define(ERR(F, A), error_logger:error_msg("*** ERROR (~w:~b) ~p " ++ F ++ "~n", [?MODULE, ?LINE, self() | A])).

-endif. % MT_LOG_H
