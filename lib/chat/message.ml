type role =
     | System
     | User
     | Assistant

type t = {
    role: role;
    content: string;
  }
