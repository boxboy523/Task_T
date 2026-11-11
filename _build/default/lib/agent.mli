type ('i, 'o) t

val create : ('i -> 'o Task.t) -> ('i, 'o) t
val apply : ('i, 'o) t -> 'i -> 'o Task.t
val run : ('i, 'o) t -> 'i -> 'o
