%%
%% Autogenerated by Thrift Compiler (0.8.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(mtc_schema_types).

-include("mtc_schema_types.hrl").

-export([struct_info/1, struct_info_ext/1]).

struct_info('mt_google_analytics') ->
  {struct, [{1, string}, {2, string}]}
;

struct_info('mt_person') ->
  {struct, [{1, string}, {2, string}, {3, string}, {4, string}, {5, string}, {6, string}, {7, string}, {8, string}, {9, string}, {10, {struct, {'mtc_schema_types', 'mt_google_analytics'}}}, {11, {list, string}}]}
;

struct_info('mt_author') ->
  {struct, [{1, string}, {2, string}]}
;

struct_info('mt_comment') ->
  {struct, [{1, string}, {2, i32}, {3, {list, i32}}, {4, {struct, {'mtc_schema_types', 'mt_author'}}}, {5, string}, {6, i64}, {7, string}, {8, string}]}
;

struct_info('mt_comment_ref') ->
  {struct, [{1, {list, i32}}, {2, string}, {3, i32}]}
;

struct_info('mt_post') ->
  {struct, [{1, string}, {2, {struct, {'mtc_schema_types', 'mt_author'}}}, {3, string}, {4, i64}, {5, i32}, {6, {list, {struct, {'mtc_schema_types', 'mt_comment_ref'}}}}, {7, string}, {8, string}, {9, {list, string}}, {10, {list, string}}, {11, string}, {12, i64}]}
;

struct_info('mt_fb_friend') ->
  {struct, [{1, string}, {2, string}]}
;

struct_info('mt_facebook') ->
  {struct, [{1, string}, {2, string}, {3, string}, {4, string}, {5, string}, {6, string}, {7, i32}, {8, string}, {9, byte}, {10, string}, {11, string}, {12, {list, {struct, {'mtc_schema_types', 'mt_fb_friend'}}}}, {13, string}, {14, string}]}
;

struct_info('mt_tw_friend') ->
  {struct, [{1, string}, {2, string}]}
;

struct_info('mt_twitter') ->
  {struct, [{1, string}, {2, string}, {3, string}, {4, string}, {5, string}, {6, string}, {7, i32}, {8, string}, {9, {list, {struct, {'mtc_schema_types', 'mt_tw_friend'}}}}, {10, string}]}
;

struct_info('mt_stream') ->
  {struct, [{1, string}, {2, {list, string}}]}
;

struct_info('mt_cname') ->
  {struct, [{1, string}, {2, string}, {3, string}, {4, {list, {struct, {'mtc_schema_types', 'mt_stream'}}}}, {5, string}, {6, {struct, {'mtc_schema_types', 'mt_google_analytics'}}}, {7, i32}]}
;

struct_info('i am a dummy struct') -> undefined.

struct_info_ext('mt_google_analytics') ->
  {struct, [{1, undefined, string, 'account', <<>>}, {2, undefined, string, 'host', <<>>}]}
;

struct_info_ext('mt_person') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'username', <<>>}, {3, optional, string, 'password_sha1', undefined}, {4, optional, string, 'name', undefined}, {5, undefined, string, 'email', <<>>}, {6, optional, string, 'facebook_id', undefined}, {7, optional, string, 'twitter_id', undefined}, {8, undefined, string, 'posts_list_key', <<>>}, {9, undefined, string, 'comments_list_key', <<>>}, {10, optional, {struct, {'mtc_schema_types', 'mt_google_analytics'}}, 'google_analytics', undefined}, {11, optional, {list, string}, 'cnames', undefined}]}
;

struct_info_ext('mt_author') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'name', <<>>}]}
;

struct_info_ext('mt_comment') ->
  {struct, [{1, undefined, string, 'post_id', undefined}, {2, undefined, i32, 'id', 0}, {3, undefined, {list, i32}, 'parents', []}, {4, undefined, {struct, {'mtc_schema_types', 'mt_author'}}, 'author', #mt_author{}}, {5, undefined, string, 'body', <<>>}, {6, undefined, i64, 'timestamp', undefined}, {7, optional, string, 'origin', undefined}, {8, optional, string, 'client', undefined}]}
;

struct_info_ext('mt_comment_ref') ->
  {struct, [{1, undefined, {list, i32}, 'parents', []}, {2, undefined, string, 'comment_key', <<>>}, {3, optional, i32, 'id', undefined}]}
;

struct_info_ext('mt_post') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, {struct, {'mtc_schema_types', 'mt_author'}}, 'author', #mt_author{}}, {3, undefined, string, 'body', <<>>}, {4, undefined, i64, 'timestamp', undefined}, {5, undefined, i32, 'comments_cnt', 0}, {6, undefined, {list, {struct, {'mtc_schema_types', 'mt_comment_ref'}}}, 'comments', []}, {7, optional, string, 'origin', undefined}, {8, optional, string, 'client', undefined}, {9, undefined, {list, string}, 'tags', []}, {10, undefined, {list, string}, 'circles', []}, {11, optional, string, 'title', undefined}, {12, optional, i64, 'last_mod', undefined}]}
;

struct_info_ext('mt_fb_friend') ->
  {struct, [{1, undefined, string, 'id', <<>>}, {2, undefined, string, 'name', <<>>}]}
;

struct_info_ext('mt_facebook') ->
  {struct, [{1, undefined, string, 'id', <<>>}, {2, undefined, string, 'name', <<>>}, {3, optional, string, 'first_name', undefined}, {4, optional, string, 'middle_name', undefined}, {5, optional, string, 'last_name', undefined}, {6, undefined, string, 'link', <<>>}, {7, undefined, i32, 'gender',   0}, {8, undefined, string, 'email', <<>>}, {9, undefined, byte, 'timezone', 0}, {10, optional, string, 'updated_time', undefined}, {11, optional, string, 'locale', undefined}, {12, undefined, {list, {struct, {'mtc_schema_types', 'mt_fb_friend'}}}, 'friends', []}, {13, optional, string, 'username', undefined}, {14, optional, string, 'metalkia_id', undefined}]}
;

struct_info_ext('mt_tw_friend') ->
  {struct, [{1, undefined, string, 'id', <<>>}, {2, optional, string, 'name', undefined}]}
;

struct_info_ext('mt_twitter') ->
  {struct, [{1, undefined, string, 'id', <<>>}, {2, undefined, string, 'screen_name', <<>>}, {3, undefined, string, 'name', <<>>}, {4, undefined, string, 'description', <<>>}, {5, undefined, string, 'url', <<>>}, {6, undefined, string, 'timezone', <<>>}, {7, undefined, i32, 'utc_offset', undefined}, {8, undefined, string, 'locale', <<>>}, {9, undefined, {list, {struct, {'mtc_schema_types', 'mt_tw_friend'}}}, 'friends', []}, {10, optional, string, 'metalkia_id', undefined}]}
;

struct_info_ext('mt_stream') ->
  {struct, [{1, undefined, string, 'username', <<>>}, {2, undefined, {list, string}, 'tags', []}]}
;

struct_info_ext('mt_cname') ->
  {struct, [{1, undefined, string, 'cname', <<>>}, {2, undefined, string, 'title', <<>>}, {3, undefined, string, 'owner', <<>>}, {4, undefined, {list, {struct, {'mtc_schema_types', 'mt_stream'}}}, 'streams', []}, {5, optional, string, 'logo', undefined}, {6, optional, {struct, {'mtc_schema_types', 'mt_google_analytics'}}, 'google_analytics', undefined}, {7, undefined, i32, 'type',   1}]}
;

struct_info_ext('i am a dummy struct') -> undefined.

