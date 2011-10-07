-ifndef(MT_RECORDS_H).
-define(MT_RECORDS_H, true).

-record(mt_comment, {
  author             :: iolist(),
  body = ""          :: iolist(),
  timestamp = 0      :: integer(),
  comments = 0       :: integer(),
  parents = []       :: [list()]
}).

-record(mt_post, {
  author             :: iolist(),
  body = ""          :: iolist(),
  timestamp = 0      :: integer(),
  comments_cnt = 0   :: integer(),
  comments = []      :: [#mt_comment{}]
}).

-endif. % MT_RECORDS_H
