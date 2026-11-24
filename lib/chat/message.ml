type role =
     | System
     | User
     | Assistant

type t = {
    role: role;
    content: string;
  }

let str_to_role = function
  | "system" -> Ok System
  | "user" -> Ok User
  | "assistant" -> Ok Assistant
  | _ -> Error "Invalid role string"

let role_to_str = function
  | System -> "system"
  | User -> "user"
  | Assistant -> "assistant"
