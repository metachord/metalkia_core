-module(mtc_notify).

-compile([export_all]).

-include_lib("metalkia_core/include/mt_records.hrl").
-include_lib("metalkia_core/include/mt_log.hrl").
-include_lib("metalkia_core/include/mt_util.hrl").

send(email, To, {From, Subj, Text}) when
  is_list(To) orelse is_binary(To) ->
  email(To, From, Subj, Text);
send(email, #mt_person{email = To}, {From, Subj, Text}) ->
  email(To, From, Subj, Text).

email(To, From, Subj, Text) ->
  Message = io_lib:format(
    "to:~ts\n"
    "from:~ts\n"
    "subject:~ts\n"
    "\n"
    "~ts",
    [To, From, Subj, Text]),
  Port = open_port({spawn, mtc:get_env(sendmail, "/usr/sbin/sendmail -t")}, [use_stdio, exit_status, binary]),
  port_command(Port, unicode:characters_to_binary(Message)),
  port_close(Port).
