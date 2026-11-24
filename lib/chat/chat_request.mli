type role =
  | System
  | User
  | Assistant

type message = {
  role : role;
  content : string;
}

type t = {
  messages : message list;
  max_tokens : int option;
}

val to_json : t -> string -> Yojson.Safe.t
val send : Model_connection.t -> t -> (string, string) result Lwt.t
