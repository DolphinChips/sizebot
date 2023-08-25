open Lwt.Syntax
open Lwt.Infix
open Tg.Types.Message
open Tg.Types.User
open Tg.Types.Chatmember

let form_body msg text =
  let json =
    `Assoc
      [ "method", `String "sendMessage"
      ; "chat_id", `Int msg.chat_id
      ; "text", `String text
      ; "reply_to_message_id", `Int msg.id ]
  in
  Yojson.Safe.to_string json
;;

let form_body_cm msg len = form_body msg (string_of_int len ^ "см")

let t2_fst (x, _) = x

let t2_snd (_, x) = x

let call_tg token (name, query) =
  let uri =
    Uri.make
      ~scheme:"https"
      ~host:"api.telegram.org"
      ~path:(String.concat "" [ "bot"; token; "/"; name ])
      ~query
      ()
  in
  let* _, body = Cohttp_lwt_unix.Client.get uri in
  let* body = Cohttp_lwt.Body.to_string body in
  let+ () = Lwt_io.write_line Lwt_io.stderr body in
  body |> Yojson.Safe.from_string |> Yojson.Safe.Util.path [ "result" ]
;;

let measure msg bot =
  Cocksizebot.get_size bot msg.from_id
  >|= t2_fst
  >|= form_body_cm msg
;;

let selfaverage msg bot =
  Cocksizebot.get_size bot msg.from_id
  >|= t2_snd
  >|= form_body_cm msg
;;

let board_on msg bot =
  if msg.chat_id > 0 then
    Lwt.return @@ form_body msg "Пропиши это в беседе, дурачок"
  else
    let+ () = Cocksizebot.add_user bot msg.from_id msg.chat_id in
    form_body msg "Добавлен"
;;

let format_name { first_name; last_name; _ } =
  if last_name = "" then
    first_name
  else
    String.concat " " [ first_name; last_name ]
;;

let for_all_users f msg bot token =
  if msg.chat_id > 0 then
    Lwt.return @@ form_body msg "Пропиши это в беседе, дурачок"
  else begin
    let* members =
      Cocksizebot.get_users bot msg.chat_id
      >|= List.map (Tg.Methods.get_chat_member msg.chat_id)
      >>= Lwt_list.map_p (call_tg token)
      >|= (List.filter_map (fun o -> Option.bind o Tg.Types.Chatmember.of_yojson))
    in
    let+ sizes = Lwt_list.map_s (fun u -> Cocksizebot.get_size bot u.user.id >|= fun t -> (u.user, f t)) members in
    sizes
    |> List.sort (fun (_, s1) (_, s2) -> -(compare s1 s2)) 
    |> List.map (fun (u, size) -> String.concat "" [ format_name u; ": "; string_of_int size; "см" ])
    |> String.concat "\n"
    |> form_body msg
  end
;;

let all = for_all_users t2_fst

let average = for_all_users t2_snd
