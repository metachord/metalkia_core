namespace cpp metalkia
namespace erl metalkia


typedef binary PersonId

enum Mt_gender {
  UNKNOWN   = 0,
  MALE      = 1,
  FEMALE    = 2
}

struct Mt_google_analytics {
  1:  binary               account,
  2:  binary               host,
}

struct Mt_yandex_metrika {
  1:  binary               id,
}

struct Mt_person {
  1:  PersonId               id,
  2:  binary                 username,
  3:  optional binary        password_sha1,
  4:  optional binary        name,
  5:  binary                 email,
  6:  optional binary        facebook_id,
  7:  optional binary        twitter_id,
  8:  binary                 posts_list_key,
  9:  binary                 comments_list_key,
  10: optional Mt_google_analytics  google_analytics,
  11: optional list<binary>  cnames,
  12: optional Mt_yandex_metrika    yandex_metrika,
}

struct Mt_author {
  1: PersonId               id,
  2: binary                 name
}

enum Mt_format {
  HTML      = 0,
  MARKDOWN  = 1,
}

typedef binary PostId
typedef i32 CommentId

struct Mt_comment {
  1: PostId             post_id,
  2: CommentId          id = 0,
  3: list<CommentId>    parents,
  4: Mt_author          author,
  5: binary             body,
  6: i64                timestamp,
  7: optional binary    origin,
  8: optional binary    client,
  9: optional Mt_format format = Mt_format.HTML,
  10:optional binary    body_html,
}

struct Mt_comment_ref {
  1:  list<CommentId>       parents,
  2:  binary                comment_key,
  3:  optional CommentId    id,
}

struct Mt_post {
  1:  PostId                  id,
  2:  Mt_author               author,
  3:  binary                  body,
  4:  i64                     timestamp,
  5:  i32                     comments_cnt = 0,
  6:  list<Mt_comment_ref>    comments,
  7:  optional binary         origin,
  8:  optional binary         client,
  9:  list<binary>            tags,
  10: list<binary>            circles,
  11: optional binary         title,
  12: optional i64            last_mod,
  13: optional Mt_format      format = Mt_format.HTML,
  14: optional binary         body_html,
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
  13: optional binary       username,
  14: optional PersonId     metalkia_id
}

struct Mt_tw_friend {
  1: binary            id,
  2: optional binary   name
}

struct Mt_twitter {
  1:  binary                id,
  2:  binary                screen_name,
  3:  binary                name,
  4:  binary                description,
  5:  binary                url,
  6:  binary                timezone,
  7:  i32                   utc_offset,
  8:  binary                locale,
  9:  list<Mt_tw_friend>    friends,
  10: optional PersonId     metalkia_id
}

struct Mt_stream {
  1:  binary                username,
  2:  list<binary>          tags
}

enum Mt_cname_type {
  UNKNOWN     = 0,
  CNAME       = 1,
  LOCAL       = 2,
}

struct Mt_cname {
  1:  binary                cname,
  2:  binary                title,
  3:  binary                owner,
  4:  list<Mt_stream>       streams,
  5:  optional binary       logo,
  6:  optional Mt_google_analytics  google_analytics,
  7:  Mt_cname_type         type = Mt_cname_type.CNAME,
  8:  optional Mt_yandex_metrika    yandex_metrika,
}
