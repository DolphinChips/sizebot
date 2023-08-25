type t =
  { id : int
  ; from_id : int
  ; chat_id : int
  ; text : string
  ; entities : Messageentity.t list }

let of_yojson j =
  let open Util.Yojson in
  let ( >>= ) = Option.bind in
  let ( >|= ) o f = Option.map f o in
  let ( let* ) = ( >>= ) in
  let ( let+ ) = ( >|= ) in

  let* id = path [ "message_id" ] j >>= to_int_option in
  let* from_id = path [ "from"; "id" ] j >>= to_int_option in
  let* chat_id = path [ "chat"; "id" ] j >>= to_int_option in
  let* text = path [ "text" ] j >>= to_string_option in
  let+ entities =
    path [ "entities" ] j
    >>= to_list_option
    >>= List.fold_left
      (fun acc e ->
        let* acc = acc in
        let+ entity = Messageentity.of_yojson e in
        entity :: acc)
      (Some [])
  in
  { id; from_id; chat_id; text; entities }
