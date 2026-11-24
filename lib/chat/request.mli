type t = {
  messages : Message.t list;
  max_tokens : int option;
}

val to_json : t -> string -> Yojson.Safe.t
val send : Model_connection.t -> t -> (string, string) result Lwt.t
