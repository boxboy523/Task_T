type connection = {
    endpoint: string;
    model: string;
  }

type location = Local | Cloud | Deterministic

let location_to_string = function
  | Local -> "local"
  | Cloud -> "cloud"
  | Deterministic -> "deterministic"

let string_to_location = function
  | "local" -> Ok Local
  | "cloud" -> Ok Cloud
  | "deterministic" -> Ok Deterministic
  | _ -> Error "Invalid location string"

type id = string

type t = {
    connection: connection;
    location: location;
    id: id;
  }

let ( let* ) = Result.bind

let from_json json =
  try
    let open Yojson.Safe.Util in
    let endpoint = json |> member "endpoint" |> to_string in
    let model = json |> member "model" |> to_string in
    let id = json |> member "id" |> to_string in
    let* location = json |> member "location" |> to_string |> string_to_location in
    Ok { connection = { endpoint; model }; location; id }
  with Yojson.Json_error msg -> Error ("JSON parsing error: " ^ msg)
