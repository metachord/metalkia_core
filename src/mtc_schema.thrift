namespace cpp metalkia
namespace erl metalkia


typedef i32 PersonId

enum Mt_gender {
  UNKNOWN   = 0,
  MALE      = 1,
  FEMALE    = 2
}

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

struct Mt_fb_friend {
  1: binary    id,
  2: binary    name
}

struct Mt_facebook {
  1:  binary                id,
  2:  binary                name,
  3:  optional binary       first_name,
  4:  optional binary       middle_name,
  5:  optional binary       last_name,
  6:  binary                link,
  7:  Mt_gender             gender = Mt_gender.UNKNOWN,
  8:  binary                email,
  9:  byte                  timezone = 0,
  10: optional binary       updated_time,
  11: optional binary       locale,
  12: list<Mt_fb_friend>    friends,
  13: optional binary       username
}
