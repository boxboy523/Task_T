module Classified : sig
  type 'a t
end

type t

type request = {
    model_id: Model.id;
    chat: Chat.Request.t Classified.t;
  }

val chat_request : t -> request -> ((Chat.Response.t, string) result Task.t, string) result
