module Util.Nat


public export
natToInt : Nat -> Int
natToInt 0 = 0
natToInt (S k) = 1 + natToInt k
