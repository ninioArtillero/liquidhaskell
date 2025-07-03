{-@ LIQUID "--expect-any-error" @-}

-- | This is an instance of LiquidHaskell having a flat import namespace
-- for logic names. Here, both @Nat@ modules export a type alias with
-- the same name @INat@. With current behavior this module produces a
-- _Multiple definition of Type Alias_ error when using the alias unqualified,
-- and an _Unknown type constructor_ error with the qualified alias.
-- TEMP-NOTE: This test should fail after fixing issue #2841 and moved to @names-pos@.
module QualifiedAliases where

import Data.Int (Int32)
import qualified Nat1 as N
import Nat2

{-@ llength :: [a] -> INat @-}
llength :: [a] -> Int32
llength [] = 0
llength (x : xs) = 1 + llength xs

{-@ llength' :: [a] -> N.INat @-}
llength' :: [a] -> Int
llength' [] = 0
llength' (x : xs) = 1 + llength' xs
