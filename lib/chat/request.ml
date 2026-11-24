type t = {
    messages: Message.t list;
    max_tokens: int option;
  }

let to_json (request: t) (model_name: String.t) : Yojson.Safe.t =
  let role_to_string = function
    | Message.System -> "system"
    | Message.User -> "user"
    | Message.Assistant -> "assistant"
  in
  let messages_json =
    List.map (fun (msg : Message.t) ->
      `Assoc [
        ("role", `String (role_to_string msg.role));
        ("content", `String msg.content)
      ]
    ) request.messages
  in
  let max_tokens_json =
    match request.max_tokens with
    | Some tokens -> Some (`Int tokens)
    | None -> None
  in
  let json_assoc = [
    ("messages", `List messages_json);
  ] @ (match max_tokens_json with
       | Some tokens -> [("max_tokens", tokens)]
       | None -> [])
                   @ [("model", `String model_name); ("stream", `Bool false)]
  in
  `Assoc json_assoc

let send (model: Model.connection) (request: t) : (string, string) result Lwt.t =
  let open Lwt.Syntax in
  let json = to_json request model.model in
  let body = Yojson.Safe.to_string json in
  let* (response, body) = Cohttp_lwt_unix.Client.post
    ~headers:(Cohttp.Header.init_with "Content-Type" "application/json")
    ~body:(Cohttp_lwt.Body.of_string body)
    (Uri.of_string model.endpoint) in
  let* body_str = Cohttp_lwt.Body.to_string body in
  let status = Cohttp.Response.status response in
  let code = Cohttp.Code.code_of_status status in
  if Cohttp.Code.is_success code then
    Lwt.return (Ok body_str)
  else
    Lwt.return (Error (Printf.sprintf "HTTP %d: %s" code body_str))
