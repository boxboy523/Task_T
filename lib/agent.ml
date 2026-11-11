type ('i, 'o) t = 'i -> 'o Task.t

let create f = f

let apply agent input = agent input

let run agent input = Task.run (apply agent input)
