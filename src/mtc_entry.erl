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
         counter/1
        ]).

sput(#mt_post{} = Post) ->
  Id = counter(mt_post),
  PostId = int_to_key(Id),
  NewPost = Post#mt_post{
              id = PostId,
              timestamp = mtc_util:timestamp()
             },
  ?DBG("PUT:~n~p", [NewPost]),
  Data = mtc_thrift:write(NewPost),
  ok = mtriak:put_obj_value(undefined, Data, <<"posts">>, PostId),
  PostId;
sput(#mt_comment{post_id = PostId, parents = PrevParents} = Comment) ->
  Bucket = <<"posts">>,
  DbPid = mtriak:get_pid(),
  {PostIo, Object} = mtriak:get_obj_value_to_modify(DbPid, Bucket, PostId),
  #mt_post{comments_cnt = CommCnt, comments = Comments} = Post =
    mtc_thrift:read(mt_post, PostIo),

  NewId = CommCnt+1,
  NewComment = Comment#mt_comment{
                 id = NewId,
                 parents = PrevParents ++ [NewId],
                 timestamp = mtc_util:timestamp()
                },
  NewPost = Post#mt_post{comments_cnt = NewId, comments = Comments++[NewComment]},
  ?DBG("PUT:~n~p", [NewPost]),
  mtriak:put_obj_value(DbPid, Object, mtc_thrift:write(NewPost), Bucket, PostId),
  ?a2b(NewId);
sput(#mt_facebook{id = FbId} = FbProfile) ->
  ?DBG("PUT:~n~p", [FbProfile]),
  Data = mtc_thrift:write(FbProfile),
  ok = mtriak:put_obj_value(undefined, Data, <<"facebook">>, FbId),
  FbId.

sget(mt_post = StructName, Key) ->
  case mtriak:get_obj_value(<<"posts">>, Key) of
    PostIo when is_list(PostIo) orelse
                is_binary(PostIo) ->
      Result = mtc_thrift:read(StructName, PostIo),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end;
sget(mt_facebook = StructName, Key) ->
  case mtriak:get_obj_value(<<"facebook">>, Key) of
    Io when is_list(Io) orelse
            is_binary(Io) ->
      Result = mtc_thrift:read(StructName, Io),
      ?DBG("GET:~n~p", [Result]),
      Result;
    Other ->
      Other
  end.


counter(mt_post) ->
  mtriak:inc_counter(<<"posts">>).

%% Internal
int_to_key(I) ->
  iolist_to_binary(erlang:integer_to_list(I)).
