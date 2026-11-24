module Classified = Classified

type t = {
    models: (Model.id, Model.t) Hashtbl.t;
  }

let ( let* ) = Result.bind

let from_json (json: Yojson.Safe.t) : (t, string) result =
  let open Yojson.Safe.Util in
  let models_json = json |> member "models" |> to_list in
  let models = Hashtbl.create (List.length models_json) in
  let rec parse_models = function
    | [] -> Ok ()
    | model_json::rest ->
      let* model = Model.from_json model_json in
      Hashtbl.add models model.id model;
      parse_models rest
  in
  let* () = parse_models models_json in
    Ok { models }

type request = {
    model_id: Model.id;
    chat: Chat.Request.t Classified.t;
  }

let chat_request (core: t) (request: request) : ((Chat.Response.t, string) result Task.t, string) result =
  let* model = Hashtbl.find_opt core.models request.model_id |> Option.to_result ~none:"Model not found" in
  let* request = Classified.get_payload model request.chat in
  Ok (
      Task.create
        (fun () ->
          let* body = Lwt_main.run (Chat.Request.send model.connection request) in
          Chat.Response.parse body))
