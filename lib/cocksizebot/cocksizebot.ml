open Lwt.Syntax
open Lwt.Infix
module Redis = Redis_lwt
module Calendar = CalendarLib (* i prefer this name *)

type t =
  { connection : Redis.Client.connection
  ; sha1 : string }

let create ~connection ~sha1 =
  Random.self_init (); (* TODO: use local prng *)
  { connection; sha1 }

let tomorrow () =
  let today = Calendar.Date.today () in
  Calendar.Date.Period.day 1
  |> Calendar.Date.add today
  |> Calendar.Date.to_unixfloat
  |> int_of_float
  |> string_of_int

let get_size bot id =
  let+ reply =
    Redis.Client.evalsha
      bot.connection
      bot.sha1
      [ string_of_int id ]
      [ string_of_int @@ Random.int 40 + 1; tomorrow () ]
  in
  match reply with
  | `Multibulk [`Int len; `Int avg] -> (len, avg)
  | _ -> failwith ("Didn't handle " ^ (Redis.Client.string_of_reply reply))

let add_user bot id chat_id =
  Redis.Client.sadd
    bot.connection
    ((string_of_int chat_id) ^ ":members")
    (string_of_int id)
  >>= Fun.const Lwt.return_unit

let get_users bot chat_id =
  Redis.Client.smembers
    bot.connection
    ((string_of_int chat_id) ^ ":members")
  >|= List.map int_of_string
