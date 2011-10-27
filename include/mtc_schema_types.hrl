-ifndef(_mtc_schema_types_included).
-define(_mtc_schema_types_included, yeah).

%% struct mt_comment

-record(mt_comment, {id = 0 :: integer(), 
                     author = undefined :: string(), 
                     body = undefined :: string(), 
                     timestamp = undefined :: integer(), 
                     origin = undefined :: string(), 
                     client = undefined :: string(), 
                     parents = [] :: list()}).

%% struct mt_post

-record(mt_post, {id = 0 :: integer(), 
                  author = undefined :: string(), 
                  body = undefined :: string(), 
                  timestamp = undefined :: integer(), 
                  origin = undefined :: string(), 
                  client = undefined :: string(), 
                  comment_cnt = 0 :: integer(), 
                  comments = [] :: list()}).

%% struct mt_person

-record(mt_person, {id = 0 :: integer()}).

-endif.
