-module(rebar_thrift_compiler).

-export([compile/2,
         clean/2]).


-define(FAIL, throw({error, failed})).
-define(ABORT(Str, Args), rebar_utils:abort(Str, Args)).
-define(CONSOLE(Str, Args), io:format(Str, Args)).
-define(DEBUG(Str, Args), rebar_log:log(debug, Str, Args)).
-define(INFO(Str, Args), rebar_log:log(info, Str, Args)).
-define(WARN(Str, Args), rebar_log:log(warn, Str, Args)).
-define(ERROR(Str, Args), rebar_log:log(error, Str, Args)).
-define(FMT(Str, Args), lists:flatten(io_lib:format(Str, Args))).
-define(DEPRECATED(Key, Old, New, Opts, When),
        rebar_utils:deprecated(Key, Old, New, Opts, When)).

%% ===================================================================
%% Public API
%% ===================================================================

compile(Config, _AppFile) ->
  case rebar_utils:find_files("src", ".*\\.thrift$") of
    [] ->
      ok;
    FoundFiles ->
      %% Check for thriftbuffs library -- if it's not present, fail
      %% since we have.thrift files that need building
      case thrift_is_present() of
        true ->
          %% Build a list of output files - { Thrift, Beam }
          Targets = [{Thrift, types_beam_file(Thrift)} ||
                      Thrift <- FoundFiles],

          %% Compile each thrift file
          compile_each(Config, Targets);
        false ->
          ?ERROR("Thrift compiler not present in PATH!\n",
                 []),
          ?FAIL
      end
  end.


clean(_Config, _AppFile) ->
  %% Get a list of generated .beam and .hrl files and then delete them
  Thrifts = rebar_utils:find_files("src", ".*\\.thrift$"),
  Erls = [erl_files(F) || F <- Thrifts],
  Hrls = [hrl_files(F) || F <- Thrifts],
  Targets = Erls ++ Hrls,
  case Targets of
    [] ->
      ok;
    _ ->
      delete_each(lists:append(Targets))
  end.


%% ===================================================================
%% Internal functions
%% ===================================================================

thrift_is_present() ->
  true.


erl_files(Thrift) ->
  BN = filename:basename(Thrift, ".thrift"),
  filelib:wildcard(filename:join(["src", BN]) ++ "_*.erl").

hrl_files(Thrift) ->
  BN = filename:basename(Thrift, ".thrift"),
  [filename:join(["include", filename:basename(H)]) || H <- filelib:wildcard(filename:join(["src", BN]) ++ "_*.hrl")].

types_beam_file(Proto) ->
  filename:join(["ebin", filename:basename(Proto, ".thrift") ++ "_types.beam"]).

needs_compile(Thrift, Beam) ->
  ActualBeam = filename:join(["ebin", filename:basename(Beam)]),
  filelib:last_modified(ActualBeam) < filelib:last_modified(Thrift).

compile_each(_Config, []) ->
  ok;
compile_each(Config, [{Thrift, Beam} | Rest]) ->
  case needs_compile(Thrift, Beam) of
    true ->
      case os:cmd("thrift -r -out src --gen erl " ++ Thrift) of
        [] ->
          BN = filename:basename(Thrift, ".thrift"),
          HrlFiles = filelib:wildcard(filename:join(["src", BN]) ++ "_*.hrl"),
          [begin
             ok = filelib:ensure_dir(filename:join("include", filename:basename(Hrl))),
             ok = rebar_file_utils:mv(Hrl, "include")
           end || Hrl <- HrlFiles],
          ErlFiles = filelib:wildcard(filename:join(["src", BN]) ++ "_*.erl"),
          Opts = [{outdir, "ebin"}] ++ rebar_config:get(Config, erl_opts, []),
          [begin
             compile:file(Erl, Opts),
             ?CONSOLE("Compiled ~s~n", [Erl])
           end || Erl <- ErlFiles],
          ok;
        Other ->
          ?ERROR("Thrift compile of ~s failed:\n~s\n", [Thrift, Other]),
          ?FAIL
      end;
    false ->
      ok
  end,
  compile_each(Config, Rest).

delete_each([]) ->
  ok;
delete_each([File | Rest]) ->
  case file:delete(File) of
    ok ->
      ok;
    {error, enoent} ->
      ok;
    {error, Reason} ->
      ?ERROR("Failed to delete ~s: ~p\n", [File, Reason])
  end,
  delete_each(Rest).
