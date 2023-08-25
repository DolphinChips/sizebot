type t =
  { status : string
  ; user : User.t }

val of_yojson :
  Yojson.Safe.t ->
  t option
