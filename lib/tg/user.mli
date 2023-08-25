type t =
  { id : int
  ; first_name : string
  ; last_name : string }

val of_yojson :
  Yojson.Safe.t ->
  t option
