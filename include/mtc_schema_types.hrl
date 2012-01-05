-ifndef(_mtc_schema_types_included).
-define(_mtc_schema_types_included, yeah).

-define(mtc_schema_Mt_gender_UNKNOWN, 0).
-define(mtc_schema_Mt_gender_MALE, 1).
-define(mtc_schema_Mt_gender_FEMALE, 2).

-define(mtc_schema_Mt_format_HTML, 0).
-define(mtc_schema_Mt_format_MARKDOWN, 1).

-define(mtc_schema_Mt_cname_type_UNKNOWN, 0).
-define(mtc_schema_Mt_cname_type_CNAME, 1).
-define(mtc_schema_Mt_cname_type_LOCAL, 2).

%% struct mt_google_analytics

-record(mt_google_analytics, {account = <<>> :: binary(), 
                              host = <<>> :: binary()}).

%% struct mt_person

-record(mt_person, {id = undefined :: binary(), 
                    username = <<>> :: binary(), 
                    password_sha1 = undefined :: undefined | binary(), 
                    name = undefined :: undefined | binary(), 
                    email = <<>> :: binary(), 
                    facebook_id = undefined :: undefined | binary(), 
                    twitter_id = undefined :: undefined | binary(), 
                    posts_list_key = <<>> :: binary(), 
                    comments_list_key = <<>> :: binary(), 
                    google_analytics = undefined :: undefined | #mt_google_analytics{}, 
                    cnames = undefined :: undefined | list()}).

%% struct mt_author

-record(mt_author, {id = undefined :: binary(), 
                    name = <<>> :: binary()}).

%% struct mt_comment

-record(mt_comment, {post_id = undefined :: binary(), 
                     id = 0 :: integer(), 
                     parents = [] :: list(), 
                     author = #mt_author{} :: #mt_author{}, 
                     body = <<>> :: binary(), 
                     timestamp = undefined :: integer(), 
                     origin = undefined :: undefined | binary(), 
                     client = undefined :: undefined | binary(), 
                     format = 0 :: undefined | integer(), 
                     body_html = undefined :: undefined | binary()}).

%% struct mt_comment_ref

-record(mt_comment_ref, {parents = [] :: list(), 
                         comment_key = <<>> :: binary(), 
                         id = undefined :: undefined | integer()}).

%% struct mt_post

-record(mt_post, {id = undefined :: binary(), 
                  author = #mt_author{} :: #mt_author{}, 
                  body = <<>> :: binary(), 
                  timestamp = undefined :: integer(), 
                  comments_cnt = 0 :: integer(), 
                  comments = [] :: list(), 
                  origin = undefined :: undefined | binary(), 
                  client = undefined :: undefined | binary(), 
                  tags = [] :: list(), 
                  circles = [] :: list(), 
                  title = undefined :: undefined | binary(), 
                  last_mod = undefined :: undefined | integer(), 
                  format = 0 :: undefined | integer(), 
                  body_html = undefined :: undefined | binary()}).

%% struct mt_fb_friend

-record(mt_fb_friend, {id = <<>> :: binary(), 
                       name = <<>> :: binary()}).

%% struct mt_facebook

-record(mt_facebook, {id = <<>> :: binary(), 
                      name = <<>> :: binary(), 
                      first_name = undefined :: undefined | binary(), 
                      middle_name = undefined :: undefined | binary(), 
                      last_name = undefined :: undefined | binary(), 
                      link = <<>> :: binary(), 
                      gender = 0 :: integer(), 
                      email = <<>> :: binary(), 
                      timezone = 0 :: integer(), 
                      updated_time = undefined :: undefined | binary(), 
                      locale = undefined :: undefined | binary(), 
                      friends = [] :: list(), 
                      username = undefined :: undefined | binary(), 
                      metalkia_id = undefined :: undefined | binary()}).

%% struct mt_tw_friend

-record(mt_tw_friend, {id = <<>> :: binary(), 
                       name = undefined :: undefined | binary()}).

%% struct mt_twitter

-record(mt_twitter, {id = <<>> :: binary(), 
                     screen_name = <<>> :: binary(), 
                     name = <<>> :: binary(), 
                     description = <<>> :: binary(), 
                     url = <<>> :: binary(), 
                     timezone = <<>> :: binary(), 
                     utc_offset = undefined :: integer(), 
                     locale = <<>> :: binary(), 
                     friends = [] :: list(), 
                     metalkia_id = undefined :: undefined | binary()}).

%% struct mt_stream

-record(mt_stream, {username = <<>> :: binary(), 
                    tags = [] :: list()}).

%% struct mt_cname

-record(mt_cname, {cname = <<>> :: binary(), 
                   title = <<>> :: binary(), 
                   owner = <<>> :: binary(), 
                   streams = [] :: list(), 
                   logo = undefined :: undefined | binary(), 
                   google_analytics = undefined :: undefined | #mt_google_analytics{}, 
                   type = 1 :: integer()}).

-endif.
