type t

val create :
  connection : Redis_lwt.Client.connection ->
  sha1 : string ->
  t

val get_size :
  t ->
  int ->
  (int * int) Lwt.t

val add_user :
  t ->
  int ->
  int ->
  unit Lwt.t

val get_users :
  t ->
  int ->
  int list Lwt.t
