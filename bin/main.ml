open Lwt.Syntax

let handle_update token bot body =
  let empty = Lwt.return "" in

  let t =
    let ( >>= ) = Option.bind in
    let ( let* ) = ( >>= ) in
    let ( let+ ) o f = Option.map f o in
    let* msg = Yojson.Safe.Util.path [ "message" ] body >>= Tg.Types.Message.of_yojson in
    let+ cmd = Tg.Dispatcher.get_command msg in
    msg, cmd
  in
  match t with
  | Some (msg, "measure") -> Commands.measure msg bot
  | Some (msg, "selfaverage") -> Commands.selfaverage msg bot
  | Some (msg, "board_on") -> Commands.board_on msg bot
  | Some (msg, "all") -> Commands.all msg bot token
  | Some (msg, "average") -> Commands.average msg bot token
  | _ -> empty
;;


let server token =
  let* redis =
    Redis_lwt.Client.connect
      { host = "127.0.0.1"
      ; port = 6379 }
  in
  let bot =
    Cocksizebot.create 
      ~connection:redis
      ~sha1:"af9e2d3725a1351f1b8e637c77434027edcb14f6"
  in

  let open Cohttp_lwt_unix.Server in
  let callback' _conn _req body =
    let* body = Cohttp_lwt.Body.to_string body in
    let* () = Lwt_io.write_line Lwt_io.stderr body in
    let* resp_body = handle_update token bot @@ Yojson.Safe.from_string body in
    let* () = Lwt_io.write_line Lwt_io.stderr resp_body in
    respond_string
      ~status:`OK
      ~headers:(Cohttp.Header.init_with "Content-Type" "application/json")
      ~body:resp_body
      ()
  in
  let callback conn req body =
    Lwt.catch
      (fun () -> callback' conn req body)
      (fun e ->
        let* () =
          Printexc.to_string e
          |> Lwt_io.write_line Lwt_io.stderr
        in
        Lwt.fail e)
  in
  create ~mode:(`TCP (`Port 8080)) @@ make ~callback ()
;;

open Cmdliner

let token =
  let doc = "Specify Telegram bot API token" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"TOKEN" ~doc)
;;

let server_t = Term.(const Lwt_main.run $ (const server $ token))

let cmd =
  let info =
    Cmd.info
      "cocksizebot"
      ~doc:"Launch Telegram bot to measure your size"
      ~version:"%%VERSION%%"
  in
  Cmd.v info server_t
;;

let () = exit @@ Cmd.eval cmd
