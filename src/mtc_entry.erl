%%%-------------------------------------------------------------------
%%% @author Maxim Treskin <mtreskin@metachord.com>
%%% @copyright (C) 2011, Maxim Treskin
%%% @doc
%%%
%%% @end
%%% Created : 28 Oct 2011 by Maxim Treskin <mtreskin@metachord.com>
%%%-------------------------------------------------------------------
-module(mtc_entry).

-include_lib("metalkia_core/include/mt_records.hrl").
-include_lib("metalkia_core/include/mt_log.hrl").
-include_lib("metalkia_core/include/mt_util.hrl").

-export([
         sput/1,
         sget/2,
         sget/3,
         supdate/1,
         sdelete/2,
         counter/1
        ]).

sput(#mt_person{username = UserName} = Person) ->
  %%Id = counter(mt_person),
  %%PersonId = int_to_key(Id),
  PersonId = UserName,
  NewPerson = Person#mt_person{
                id = PersonId
               },
  ?DBG("PUT:~n~p", [NewPerson]),
  Data = mtc_thrift:write(NewPerson),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_person), PersonId),
  PersonId;
sput(#mt_post{author = #mt_author{id = UserId}, tags = Tags} = Post) ->
  Id = counter(mt_post),
  PostId = int_to_key(Id),
  NewPost = Post#mt_post{
              id = PostId,
              timestamp = mtc_util:timestamp()
             },
  ?DBG("PUT:~n~p", [NewPost]),
  Data = mtc_thrift:write(NewPost),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_post), PostId),

  DbPid = mtriak:get_pid(),
  TagsBucket = iolist_to_binary([UserId, "-", "tags"]),
  ?DBG("Write tags: ~p", [Tags]),
  [begin
     {PostIdsIo, Object} = mtriak:get_obj_value_to_modify(DbPid, TagsBucket, Tag),
     ?DBG("PostIdsIo: ~p", [PostIdsIo]),
     OldPosts = if is_list(PostIdsIo) -> PostIdsIo; true -> [] end,
     mtriak:put_obj_value(DbPid, Object, [PostId | OldPosts], TagsBucket, Tag)
   end || Tag <- Tags],

  PostId;
sput(#mt_comment{post_id = PostId, parents = PrevParents, author = #mt_author{name = Author}} = Comment) ->
  PostBucket = bucket_of_struct(mt_post),

  %% Create key for comment: <post id> ++ "-" ++ <timestamp> ++ "-" ++ <comment author>
  %% If users sends more than one comment per seconds it is obviously bad
  DbPid = mtriak:get_pid(),
  {PostIo, Object} = mtriak:get_obj_value_to_modify(DbPid, PostBucket, PostId),
  #mt_post{comments_cnt = CommCnt, comments = CommentRefs} = Post =
    mtc_thrift:read(mt_post, PostIo),

  Timestamp = mtc_util:timestamp(),

  NewId = CommCnt+1,
  NewParents = PrevParents ++ [NewId],
  NewComment = Comment#mt_comment{
                 id = NewId,
                 parents = NewParents,
                 timestamp = Timestamp
                },
  CommentKey = iolist_to_binary([PostId, "-", integer_to_list(Timestamp), "-", Author]),
  CommentRef = #mt_comment_ref{parents = NewParents, comment_key = CommentKey},
  NewPost = Post#mt_post{comments_cnt = NewId, comments = CommentRefs++[CommentRef]},
  ?DBG("PUT:~n~p", [NewPost]),
  mtriak:put_obj_value(DbPid, Object, mtc_thrift:write(NewPost), PostBucket, PostId),

  mtriak:put_obj_value(undefined, mtc_thrift:write(NewComment), bucket_of_struct(mt_comment), CommentKey),


  ?a2b(NewId);
sput(#mt_facebook{id = FbId} = FbProfile) ->
  ?DBG("PUT:~n~p", [FbProfile]),
  Data = mtc_thrift:write(FbProfile),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_facebook), FbId),
  FbId;
sput(#mt_twitter{id = TwId} = TwProfile) ->
  ?DBG("PUT:~n~p", [TwProfile]),
  Data = mtc_thrift:write(TwProfile),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_twitter), TwId),
  TwId;
sput(#mt_cname{cname = Name} = CName) ->
  ?DBG("PUT:~n~p", [CName]),
  Data = mtc_thrift:write(CName),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_cname), Name),
  Name.

sget(mt_person = StructName, Key) ->
  case mtriak:get_obj_value(bucket_of_struct(StructName), Key) of
    Io when is_list(Io) orelse
            is_binary(Io) ->
      Result = mtc_thrift:read(StructName, Io),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end;
sget(mt_post = StructName, Key) ->
  case mtriak:get_obj_value(bucket_of_struct(StructName), Key) of
    PostIo when is_list(PostIo) orelse
                is_binary(PostIo) ->
      Result = mtc_thrift:read(StructName, PostIo),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end;
sget(mt_facebook = StructName, Key) ->
  case mtriak:get_obj_value(bucket_of_struct(StructName), Key) of
    Io when is_list(Io) orelse
            is_binary(Io) ->
      Result = mtc_thrift:read(StructName, Io),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end;
sget(mt_twitter = StructName, Key) ->
  case mtriak:get_obj_value(bucket_of_struct(StructName), Key) of
    Io when is_list(Io) orelse
            is_binary(Io) ->
      Result = mtc_thrift:read(StructName, Io),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end;
sget(mt_cname = StructName, Key) ->
  case mtriak:get_obj_value(bucket_of_struct(StructName), Key) of
    Io when is_list(Io) orelse
            is_binary(Io) ->
      Result = mtc_thrift:read(StructName, Io),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end.

sget(tags, UserId, Tag) ->
  TagsBucket = iolist_to_binary([UserId, "-", "tags"]),
  case mtriak:get_obj_value(TagsBucket, Tag) of
    Result when is_list(Result) ->
      Result;
    _ ->
      []
  end.

supdate(#mt_person{id = Id} = Profile) ->
  ?DBG("UPDATE:~n~p", [Profile]),
  {Status, NewProfile} =
    case sget(mt_person, Id) of
      #mt_person{} = _StoredProfile ->
        %% TODO: Compare Profile and StoredProfile
        {updated, Profile#mt_person{}};
      _ ->
        {new, Profile}
    end,
  Data = mtc_thrift:write(NewProfile),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_person), Id),
  {Status, NewProfile};
supdate(#mt_facebook{id = Id} = Profile) ->
  ?DBG("UPDATE:~n~p", [Profile]),
  {Status, NewProfile} =
    case sget(mt_facebook, Id) of
      #mt_facebook{metalkia_id = MetalkiaId} = _StoredProfile ->
        %% TODO: Compare Profile and StoredProfile
        {updated, Profile#mt_facebook{metalkia_id = MetalkiaId}};
      _ ->
        {new, Profile}
    end,
  Data = mtc_thrift:write(NewProfile),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_facebook), Id),
  {Status, NewProfile};
supdate(#mt_twitter{id = Id} = Profile) ->
  ?DBG("UPDATE:~n~p", [Profile]),
  {Status, NewProfile} =
    case sget(mt_twitter, Id) of
      #mt_twitter{metalkia_id = MetalkiaId} = _StoredProfile ->
        %% TODO: Compare Profile and StoredProfile
        {updated, Profile#mt_twitter{metalkia_id = MetalkiaId}};
      _ ->
        {new, Profile}
    end,
  Data = mtc_thrift:write(NewProfile),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_twitter), Id),
  {Status, NewProfile};
supdate(#mt_cname{cname = Name} = CName) ->
  ?DBG("UPDATE:~n~p", [CName]),
  {Status, NewCName} =
    case sget(mt_cname, Name) of
      #mt_cname{streams = _Streams} = _StoredCName ->
        %% TODO: Compare CNames
        {updated, CName#mt_cname{}};
      _ ->
        {new, CName}
    end,
  Data = mtc_thrift:write(NewCName),
  ok = mtriak:put_obj_value(undefined, Data, bucket_of_struct(mt_cname), Name),
  {Status, NewCName}.

sdelete(StructName, Key) ->
  mtriak:delete(bucket_of_struct(StructName), Key).

counter(mt_person) ->
  mtriak:inc_counter(<<"persons">>);
counter(mt_post) ->
  mtriak:inc_counter(<<"posts">>).

%% Internal
int_to_key(I) ->
  iolist_to_binary(erlang:integer_to_list(I)).

bucket_of_struct(StructName) ->
  case StructName of
    mt_person -> <<"persons">>;
    mt_post -> <<"posts">>;
    mt_comment -> <<"comments">>;
    mt_facebook -> <<"facebook">>;
    mt_twitter -> <<"twitter">>;
    mt_cname -> <<"cnames">>
  end.
