open Message
open Messageentity

let get_command { entities; text; _ } =
  let ( let+ ) o f = Option.map f o in
  let+ len =
    entities
    |> List.find_map (function
      | { tag = "bot_command"; offset = 0; length = l } -> Some l
      | _ -> None)
  in
  (* telegram says that length specifies amount of utf-16 codepoints
     but it should be fine, command is at the start of the message that it should be all ascii
     so we won't need to actually decode anything *)
  let[@warning "-8"] command::_ = String.sub text 1 (len - 1) |> String.split_on_char '@' in
  command
