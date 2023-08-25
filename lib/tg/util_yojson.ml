include Yojson.Safe.Util

let to_list_option = function
  | `List l -> Some l
  | _ -> None
