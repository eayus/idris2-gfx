module Util.L2Pair


infixr 2 ~~


public export
data L2Pair : (a : Type) -> (b : a -> Type) -> Type where
    (~~) : (x : a) -> (1 _ : b x) -> L2Pair a b
