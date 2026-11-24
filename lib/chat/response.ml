type t = {
  id: string;
  object_type: string;
  created: int;
  model: string;
  choices: choice list;
  }

type choice = {
  index: int;
  message: Message.t;
  finish_reason: string;
  }

let parse (body: string) : (string, string) result =
  try
    let json = Yojson.Safe.from_string body in
    let open Yojson.Safe.Util in
    let choices = member "choices" json in
    let first_choice = List.hd (to_list choices) in
    let message = member "message" first_choice in
    let content = member "content" message |> to_string in
    Ok content
  with Yojson.Json_error msg -> Error ("JSON parsing error: " ^ msg)
