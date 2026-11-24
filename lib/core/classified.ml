type level = | Public | Private | Secret
type 'a t = {
    level: level;
    payload: 'a;
  }

let ( let* ) = Result.bind

let get_payload (model: Model.t) (classified: 'a t) : ('a, string) result =
  match classified.level with
  | Public -> Ok classified.payload
  | Private -> (match model.location with
    | Model.Local -> Ok classified.payload
    | Model.Cloud -> Error "Cannot access private payload in cloud model"
    | Model.Deterministic -> Ok classified.payload)
  | Secret -> Error "Cannot access secret payload"
