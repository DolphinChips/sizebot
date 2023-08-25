val measure :
  Tg.Types.Message.t ->
  Cocksizebot.t ->
  string Lwt.t

val selfaverage :
  Tg.Types.Message.t ->
  Cocksizebot.t ->
  string Lwt.t

val board_on :
  Tg.Types.Message.t ->
  Cocksizebot.t ->
  string Lwt.t

val all :
  Tg.Types.Message.t ->
  Cocksizebot.t ->
  string ->
  string Lwt.t

val average :
  Tg.Types.Message.t ->
  Cocksizebot.t ->
  string ->
  string Lwt.t

