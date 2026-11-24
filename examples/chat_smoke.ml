open Taskt

let ( let* ) = Result.bind

let () =
  let connection : Model.connection = {
    endpoint = "http://desktop:8080/v1/chat/completions";
    model = "qwen3.8-flash-next-gyro-gyro-m";
  } in
  let request : Chat.Request.t = {
    messages = [
      { role = User; content = "Reply with a short greeting in Korean." };
    ];
    max_tokens = Some 256;
  } in
  let result =
    let* body = Lwt_main.run (Chat.Request.send connection request) in
    let* response = Chat.Response.parse body in
    List.nth_opt response.choices 0 |> Option.to_result ~none:"No choices returned"
  in
  match result with
  | Ok choice ->
     let message = choice.message in
     Printf.printf "Role: %s\nContent: %s\n"
       (Chat.Message.role_to_str message.role)
       message.content
  | Error msg ->
     Printf.eprintf "Error: %s\n" msg;
     exit 1
