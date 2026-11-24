open Taskt

let () =
  let connection : Model_connection.t = {
    endpoint = "http://desktop:8080/v1/chat/completions";
    model = "qwen3.8-flash-next-gyro-gyro-m";
  } in
  let request : Chat.Request.t = {
    messages = [
      { role = User; content = "Reply with a short greeting in Korean." };
    ];
    max_tokens = Some 256;
  } in
  match Lwt_main.run (Chat.Request.send connection request) with
  | Ok body -> print_endline body
  | Error message ->
      prerr_endline message;
      exit 1
