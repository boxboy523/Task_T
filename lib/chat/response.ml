type choice = {
  index: int;
  message: Message.t;
  finish_reason: string;
  }

type t = {
  id: string;
  object_type: string;
  created: int;
  model: string;
  choices: choice list;
  }

let ( let* ) = Result.bind

let parse (body: string) : (t, string) result =
  try
    let json = Yojson.Safe.from_string body in
    let open Yojson.Safe.Util in
    let id = member "id" json |> to_string in
    let object_type = member "object" json |> to_string in
    let created = member "created" json |> to_int in
    let model = member "model" json |> to_string in
    let* choices = member "choices" json |> to_list |> List.map (fun choice_json ->
      let index = member "index" choice_json |> to_int in
      let message_json = member "message" choice_json in
      let content = member "content" message_json |> to_string in
      let* role = member "role" message_json |> to_string |> Message.str_to_role in
      let finish_reason = member "finish_reason" choice_json |> to_string in
      Ok { index; message = { Message.role; content }; finish_reason }) |> (
        fun results ->
        let rec collect acc = function
          | [] -> Ok (List.rev acc)
          | (Ok v)::xs -> collect (v::acc) xs
          | (Error e)::_ -> Error e
        in
        collect [] results) in
    Ok { id; object_type; created; model; choices }
  with Yojson.Json_error msg -> Error ("JSON parsing error: " ^ msg)
