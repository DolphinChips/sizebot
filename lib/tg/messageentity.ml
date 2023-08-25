type t =
  { tag : string
  ; offset : int
  ; length : int }

let of_yojson j =
  let open Util.Yojson in
  let ( >>= ) = Option.bind in
  let ( >|= ) o f = Option.map f o in
  let ( let* ) = ( >>= ) in
  let ( let+ ) = ( >|= ) in

  let* tag = path [ "type" ] j >>= to_string_option in
  let* offset = path [ "offset" ] j >>= to_int_option in
  let+ length = path [ "length" ] j >>= to_int_option in
  { tag; offset; length }
