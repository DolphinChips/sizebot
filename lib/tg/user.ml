type t =
  { id : int
  ; first_name : string
  ; last_name : string }

let of_yojson j =
  let open Util.Yojson in
  let ( >>= ) = Option.bind in
  let ( >|= ) o f = Option.map f o in
  let ( let* ) = ( >>= ) in
  let ( let+ ) = ( >|= ) in

  let* id = path [ "id" ] j >>= to_int_option in
  let+ first_name = path [ "first_name" ] j >>= to_string_option in
  let last_name = path [ "last_name" ] j |> Option.value ~default:(`String "") |> to_string in
  { id; first_name; last_name }
