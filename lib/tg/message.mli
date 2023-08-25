type t =
  { id : int
  ; from_id : int
  ; chat_id : int
  ; text : string
  ; entities : Messageentity.t list }

val of_yojson : Yojson.Safe.t -> t option
