type 'a t = unit -> 'a

(* create Task from function *)
let create f = f

(* run Task *)
let run t = t ()

(* change type in task *)
let map f t () = f (run t)

(* task is monadic *)
let bind f t () = run (f (run t))
