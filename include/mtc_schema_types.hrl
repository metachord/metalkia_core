-ifndef(_mtc_schema_types_included).
-define(_mtc_schema_types_included, yeah).

-define(mtc_schema_Mt_gender_UNKNOWN, 0).
-define(mtc_schema_Mt_gender_MALE, 1).
-define(mtc_schema_Mt_gender_FEMALE, 2).

%% struct mt_person

-record(mt_person, {id = 0 :: integer(), 
                    name = undefined :: string()}).

%% struct mt_comment

-record(mt_comment, {post_id = undefined :: string(), 
                     id = 0 :: integer(), 
                     parents = [] :: list(), 
                     author = #mt_person{} :: #mt_person{}, 
                     body = undefined :: string(), 
                     timestamp = undefined :: integer(), 
                     origin = undefined :: string(), 
                     client = undefined :: string()}).

%% struct mt_post

-record(mt_post, {id = undefined :: string(), 
                  author = #mt_person{} :: #mt_person{}, 
                  body = undefined :: string(), 
                  timestamp = undefined :: integer(), 
                  comments_cnt = 0 :: integer(), 
                  comments = [] :: list(), 
                  origin = undefined :: string(), 
                  client = undefined :: string()}).

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
                      username = undefined :: string()}).

-endif.
