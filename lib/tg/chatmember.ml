type t =
  { status : string
  ; user : User.t }


let of_yojson j =
  let open Util.Yojson in
  let ( >>= ) = Option.bind in
  let ( >|= ) o f = Option.map f o in
  let ( let* ) = ( >>= ) in
  let ( let+ ) = ( >|= ) in
  
  let* status = path [ "status" ] j >>= to_string_option in
  let+ user = path [ "user" ] j >>= User.of_yojson in
  { status; user }
