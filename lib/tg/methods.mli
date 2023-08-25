type result = string * (string * string list) list

val get_chat_member :
  int ->
  int ->
  result
