-module(mtc_notify).

-compile([export_all]).

-include_lib("metalkia_core/include/mt_records.hrl").
-include_lib("metalkia_core/include/mt_log.hrl").
-include_lib("metalkia_core/include/mt_util.hrl").

send(email, To, {From, Subj, Text}, Headers) when
  is_list(To) orelse is_binary(To) ->
  email(To, From, Subj, Text, Headers);
send(email, #mt_person{email = To}, {From, Subj, Text}, Headers) ->
  email(To, From, Subj, Text, Headers);
send(_, _, _, _) ->
  ok.

email(To, From, Subj, Data, Headers) ->
  ?DBG("Send mail to ~p", [To]),

  Enq =
  fun(T) ->
    re:replace(T, "=", "=3D", [global, {return, list}, unicode])
  end,

  F0 = "To: ~ts\n"
  "From: ~ts\n"
  "Subject: ~ts\n"
  "X-Mailer: Metalkia Email Notify\n"
  "Date: " ++ httpd_util:rfc1123_date() ++ "\n" ++
  lists:flatten([io_lib:format("~s: ~ts\n", [N, V]) || {N, V} <- Headers]),

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

new_comment(
  #mt_post{id = PostId, author = #mt_author{id = PostAuthorId}, comments = CommentRefs},
  #mt_comment{id = CommentId, parents = Parents, author = #mt_author{id = CommentAuthorId}, body = CommentBody}) ->

  %% TODO: add message composer system
  Subject = "Reply on #" ++ ?a2l(PostId),

  PrevParents =
  case lists:reverse(Parents) of
    [] -> [];
    [_|PrevParentsRev] -> lists:reverse(PrevParentsRev)
  end,

  Blockquote = fun(T) ->
    [
      "<blockquote style='border-left: #000040 2px solid; margin-left: 0px; margin-right: 0px; padding-left: 15px; padding-right: 0px'>",
      T,
      "</blockquote>"
    ]
  end,

  ParentHeader =
  case lists:reverse(PrevParents) of
    [] ->
      ?DBG("Empty previous parents list", []),
      %% Reply on post
      [];
    [ParentCid|_] ->
      %% Reply on comment
      ?DBG("ParentCid: ~p", [ParentCid]),
      [ParentCKey] = [PKey || #mt_comment_ref{id = PCid, comment_key = PKey} <- CommentRefs, PCid =:= ParentCid],
      case mtc_entry:sget(mt_comment, ?a2b(ParentCKey)) of
        #mt_comment{author = #mt_author{id = ParentAuthorId}, body = ParentCommentBody} ->
          case mtc_entry:sget(mt_person, ParentAuthorId) of
            #mt_person{name = ParentAuthorName} ->
              iolist_to_binary([
                "<a href=\"" ++ mtws_common:user_blog(ParentAuthorId, ["/profile"]) ++ "\">",
                if (ParentAuthorName =/= undefined) andalso (ParentAuthorName =/= <<>>) -> ParentAuthorName; true -> ParentAuthorId end,
                "</a> wrote:",
                Blockquote(ParentCommentBody)
              ]);
            _ -> ""
          end;
        _ -> ""
      end
  end,


  Header =
  case mtc_entry:sget(mt_person, CommentAuthorId) of
    #mt_person{name = CommentAuthorName} ->
      iolist_to_binary([
        "<a href=\"" ++ mtws_common:user_blog(CommentAuthorId, ["/profile"]) ++ "\">",
        if CommentAuthorName =/= undefined -> CommentAuthorName; true -> CommentAuthorId end,
        "</a> replied:",
        Blockquote(CommentBody)
      ]);
    _ -> ""
  end,

  NotifyBody = iolist_to_binary(
    [
      ParentHeader,
      "<br />",
      Header,
      "\n"
      "<p><a href=\"" ++ mtws_common:user_blog(PostAuthorId, ["/post/", ?a2l(PostId)], [], [?a2l(CommentId)]) ++ "\">"
      "Link"
      "</a></p>"
  ]),

  NotifyText = mtws_sanitizer:sanitize("text", NotifyBody),
  NotifyHtml = NotifyBody,


  InReplyTo = iolist_to_binary(
    [
      "<", "comment-", ?a2l(PostId),
      case lists:reverse(PrevParents) of [] -> []; [ParId|_] -> ["-", ?a2l(ParId)] end,
      "@" ++ mtc:get_env(mail_domain), ">"
    ]
  ),
  Headers = [{"In-Reply-To", InReplyTo}],

  Persons = [mtc_entry:sget(mt_person, NId)
  || NId <- lists:usort([PostAuthorId | [IdForNotify
    || #mt_comment{author = #mt_author{id = IdForNotify}} <-
      %%
      [mtc_entry:sget(mt_comment, CKey)
        || CId <- PrevParents, #mt_comment_ref{id = RefId, comment_key = CKey} <-
          CommentRefs, CId =:= RefId]]])],


  [mtc_notify:send(email, PersonForNotify, {"noreply@metalkia.com", Subject, {NotifyText, NotifyHtml}}, Headers) || #mt_person{} = PersonForNotify <- Persons].
