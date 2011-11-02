-ifndef(_mtc_schema_types_included).
-define(_mtc_schema_types_included, yeah).

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

-endif.
