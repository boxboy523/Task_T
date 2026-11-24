type connection = {
    endpoint: string;
    model: string;
  }

type location = Local | Cloud | Deterministic

val location_to_string : location -> string
val string_to_location : string -> (location, string) result

type id = string

type t = {
    connection: connection;
    location: location;
    id: id;
  }

val from_json : Yojson.Safe.t -> (t, string) result
