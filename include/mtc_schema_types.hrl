-ifndef(_mtc_schema_types_included).
-define(_mtc_schema_types_included, yeah).

-define(mtc_schema_Mt_gender_UNKNOWN, 0).
-define(mtc_schema_Mt_gender_MALE, 1).
-define(mtc_schema_Mt_gender_FEMALE, 2).

%% struct mt_google_analytics

-record(mt_google_analytics, {account = undefined :: string(), 
                              host = undefined :: string()}).

%% struct mt_person

-record(mt_person, {id = undefined :: string(), 
                    username = undefined :: string(), 
                    password_sha1 = undefined :: string(), 
                    name = undefined :: string(), 
                    email = undefined :: string(), 
                    facebook_id = undefined :: string(), 
                    twitter_id = undefined :: string(), 
                    posts_list_key = undefined :: string(), 
                    comments_list_key = undefined :: string(), 
                    google_analytics = #mt_google_analytics{} :: #mt_google_analytics{}}).

%% struct mt_author

-record(mt_author, {id = undefined :: string(), 
                    name = undefined :: string()}).

%% struct mt_comment

-record(mt_comment, {post_id = undefined :: string(), 
                     id = 0 :: integer(), 
                     parents = [] :: list(), 
                     author = #mt_author{} :: #mt_author{}, 
                     body = undefined :: string(), 
                     timestamp = undefined :: integer(), 
                     origin = undefined :: string(), 
                     client = undefined :: string()}).

%% struct mt_comment_ref

-record(mt_comment_ref, {parents = [] :: list(), 
                         comment_key = undefined :: string(), 
                         id = undefined :: integer()}).

%% struct mt_post

-record(mt_post, {id = undefined :: string(), 
                  author = #mt_author{} :: #mt_author{}, 
                  body = undefined :: string(), 
                  timestamp = undefined :: integer(), 
                  comments_cnt = 0 :: integer(), 
                  comments = [] :: list(), 
                  origin = undefined :: string(), 
                  client = undefined :: string(), 
                  tags = [] :: list(), 
                  circles = [] :: list(), 
                  title = undefined :: string()}).

%% struct mt_fb_friend

-record(mt_fb_friend, {id = undefined :: string(), 
                       name = undefined :: string()}).

%% struct mt_facebook

-record(mt_facebook, {id = undefined :: string(), 
                      name = undefined :: string(), 
                      first_name = undefined :: string(), 
                      middle_name = undefined :: string(), 
                      last_name = undefined :: string(), 
                      link = undefined :: string(), 
                      gender = 0 :: integer(), 
                      email = undefined :: string(), 
                      timezone = 0 :: integer(), 
                      updated_time = undefined :: string(), 
                      locale = undefined :: string(), 
                      friends = [] :: list(), 
                      username = undefined :: string(), 
                      metalkia_id = undefined :: string()}).

%% struct mt_tw_friend

-record(mt_tw_friend, {id = undefined :: string(), 
                       name = undefined :: string()}).

%% struct mt_twitter

-record(mt_twitter, {id = undefined :: string(), 
                     screen_name = undefined :: string(), 
                     name = undefined :: string(), 
                     description = undefined :: string(), 
                     url = undefined :: string(), 
                     timezone = undefined :: string(), 
                     utc_offset = undefined :: integer(), 
                     locale = undefined :: string(), 
                     friends = [] :: list(), 
                     metalkia_id = undefined :: string()}).

%% struct mt_stream

-record(mt_stream, {username = undefined :: string(), 
                    tags = [] :: list()}).

%% struct mt_cname

-record(mt_cname, {cname = undefined :: string(), 
                   title = undefined :: string(), 
                   owner = undefined :: string(), 
                   streams = [] :: list(), 
                   logo = undefined :: string(), 
                   google_analytics = #mt_google_analytics{} :: #mt_google_analytics{}}).

-endif.
