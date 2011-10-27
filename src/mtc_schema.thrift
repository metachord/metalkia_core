namespace cpp metalkia
namespace erl metalkia

typedef i32 CommentId

struct Mt_comment {
  1: CommentId          id = 0,
  2: binary             author,
  3: binary             body,
  4: i64                timestamp,
  5: optional binary    origin,
  6: optional binary    client,
  7: list<CommentId>    parents
}

typedef i64 PostId

struct Mt_post {
  1: PostId             id = 0,
  2: binary             author,
  3: binary             body,
  4: i64                timestamp,
  5: optional binary    origin,
  6: optional binary    client,
  7: i32                comment_cnt = 0,
  8: list<Mt_comment>   comments
}

typedef i32 PersonId

struct Mt_person {
  1: PersonId           id = 0
}
