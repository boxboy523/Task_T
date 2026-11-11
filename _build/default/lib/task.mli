type 'a t

val create : (unit -> 'a) -> 'a t
val run : 'a t -> 'a
val map : ('a -> 'b) -> 'a t -> 'b t
val bind : ('a -> 'b t) -> 'a t -> 'b t
