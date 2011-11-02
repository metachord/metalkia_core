namespace cpp metalkia
namespace erl metalkia


typedef i32 PersonId

struct Mt_person {
  1: PersonId           id = 0,
  2: optional binary    name
}

typedef binary PostId
typedef i32 CommentId

struct Mt_comment {
  1: PostId             post_id,
  2: CommentId          id = 0,
  3: list<CommentId>    parents,
  4: Mt_person          author,
  5: binary             body,
  6: i64                timestamp,
  7: optional binary    origin,
  8: optional binary    client
}

struct Mt_post {
  1: PostId             id,
  2: Mt_person          author,
  3: binary             body,
  4: i64                timestamp,
  5: i32                comments_cnt = 0,
  6: list<Mt_comment>   comments,
  7: optional binary    origin,
  8: optional binary    client
}
