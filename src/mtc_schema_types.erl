%%
%% Autogenerated by Thrift Compiler (0.8.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(mtc_schema_types).

-include("mtc_schema_types.hrl").

-export([struct_info/1, struct_info_ext/1]).

struct_info('mt_person') ->
  {struct, [{1, string}, {2, string}, {3, string}, {4, string}, {5, string}, {6, string}, {7, string}, {8, string}, {9, string}]}
;

struct_info('mt_author') ->
  {struct, [{1, string}, {2, string}]}
;

struct_info('mt_comment') ->
  {struct, [{1, string}, {2, i32}, {3, {list, i32}}, {4, {struct, {'mtc_schema_types', 'mt_author'}}}, {5, string}, {6, i64}, {7, string}, {8, string}]}
;

struct_info('mt_post') ->
  {struct, [{1, string}, {2, {struct, {'mtc_schema_types', 'mt_author'}}}, {3, string}, {4, i64}, {5, i32}, {6, {list, {struct, {'mtc_schema_types', 'mt_comment'}}}}, {7, string}, {8, string}]}
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

struct_info('i am a dummy struct') -> undefined.

struct_info_ext('mt_person') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'username', undefined}, {3, optional, string, 'password_sha1', undefined}, {4, optional, string, 'name', undefined}, {5, undefined, string, 'email', undefined}, {6, optional, string, 'facebook_id', undefined}, {7, optional, string, 'twitter_id', undefined}, {8, undefined, string, 'posts_list_key', undefined}, {9, undefined, string, 'comments_list_key', undefined}]}
;

struct_info_ext('mt_author') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'name', undefined}]}
;

struct_info_ext('mt_comment') ->
  {struct, [{1, undefined, string, 'post_id', undefined}, {2, undefined, i32, 'id', 0}, {3, undefined, {list, i32}, 'parents', []}, {4, undefined, {struct, {'mtc_schema_types', 'mt_author'}}, 'author', #mt_author{}}, {5, undefined, string, 'body', undefined}, {6, undefined, i64, 'timestamp', undefined}, {7, optional, string, 'origin', undefined}, {8, optional, string, 'client', undefined}]}
;

struct_info_ext('mt_post') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, {struct, {'mtc_schema_types', 'mt_author'}}, 'author', #mt_author{}}, {3, undefined, string, 'body', undefined}, {4, undefined, i64, 'timestamp', undefined}, {5, undefined, i32, 'comments_cnt', 0}, {6, undefined, {list, {struct, {'mtc_schema_types', 'mt_comment'}}}, 'comments', []}, {7, optional, string, 'origin', undefined}, {8, optional, string, 'client', undefined}]}
;

struct_info_ext('mt_fb_friend') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'name', undefined}]}
;

struct_info_ext('mt_facebook') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'name', undefined}, {3, optional, string, 'first_name', undefined}, {4, optional, string, 'middle_name', undefined}, {5, optional, string, 'last_name', undefined}, {6, undefined, string, 'link', undefined}, {7, undefined, i32, 'gender',   0}, {8, undefined, string, 'email', undefined}, {9, undefined, byte, 'timezone', 0}, {10, optional, string, 'updated_time', undefined}, {11, optional, string, 'locale', undefined}, {12, undefined, {list, {struct, {'mtc_schema_types', 'mt_fb_friend'}}}, 'friends', []}, {13, optional, string, 'username', undefined}, {14, optional, string, 'metalkia_id', undefined}]}
;

struct_info_ext('mt_tw_friend') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, optional, string, 'name', undefined}]}
;

struct_info_ext('mt_twitter') ->
  {struct, [{1, undefined, string, 'id', undefined}, {2, undefined, string, 'screen_name', undefined}, {3, undefined, string, 'name', undefined}, {4, undefined, string, 'description', undefined}, {5, undefined, string, 'url', undefined}, {6, undefined, string, 'timezone', undefined}, {7, undefined, i32, 'utc_offset', undefined}, {8, undefined, string, 'locale', undefined}, {9, undefined, {list, {struct, {'mtc_schema_types', 'mt_tw_friend'}}}, 'friends', []}, {10, optional, string, 'metalkia_id', undefined}]}
;

struct_info_ext('i am a dummy struct') -> undefined.

