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

email(To, From, Subj, Data) ->
  ?DBG("Send mail to ~p", [From]),

  Enq =
  fun(T) ->
    re:replace(T, "=", "=3D", [global, {return, list}, unicode])
  end,

  F0 = "To: ~ts\n"
  "From: ~ts\n"
  "Subject: ~ts\n"
  "X-Mailer: Metalkia Email Notify\n"
  "Date: " ++ httpd_util:rfc1123_date() ++ "\n",

  Message =
  case Data of
    {TextData, HtmlData} ->
      Boundary = "_---------=_" ++ mtc_util:rand_str(30),
      io_lib:format(
        F0 ++
        "MIME-Version: 1.0\n"
        "Content-Transfer-Encoding: binary\n"
        "Content-Type: multipart/alternative; boundary=\"" ++ Boundary ++ "\"\n"
        "\n"
        "This is a multi-part message in MIME format.\n"
        "\n"
        "--" ++ Boundary ++ "\n"
        "Content-Disposition: inline\n"
        "Content-Type: text/plain; charset=\"utf-8\"\n"
        "Content-Transfer-Encoding: quoted-printable\n"
        "\n"
        "~ts"
        "\n"
        "--" ++ Boundary ++ "\n"
        "Content-Disposition: inline\n"
        "Content-Type: text/html; charset=\"utf-8\"\n"
        "Content-Transfer-Encoding: quoted-printable\n"
        "\n"
        "<head><meta http-equiv=\"Content-Type\" content=\"text/html\" /></head>\n"
        "<body>\n"
        "~ts\n"
        "</body>\n"
        "\n"
        "--" ++ Boundary ++ "--"
        "\n",
        [To, From, Subj, Enq(TextData), Enq(HtmlData)]);
    TextData ->
      io_lib:format(
        F0 ++
        "\n"
        "~ts"
        "\n",
        [To, From, Subj, TextData])
  end,
  Port = open_port({spawn, mtc:get_env(sendmail, "/usr/sbin/sendmail -t")}, [use_stdio, exit_status, binary]),
  port_command(Port, unicode:characters_to_binary(Message)),
  port_close(Port).
