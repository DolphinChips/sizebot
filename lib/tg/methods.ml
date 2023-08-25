type result = string * (string * string list) list

let get_chat_member chat_id user_id =
  "getChatMember", [ "chat_id", [ string_of_int chat_id ]; "user_id", [ string_of_int user_id ] ]
