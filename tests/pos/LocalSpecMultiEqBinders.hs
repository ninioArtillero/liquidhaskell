-- | Regression test for https://github.com/ucsd-progsys/liquidhaskell/issues/2704
--
-- Local function specifications must be able to reference argument binders
-- from the enclosing equation of a multi-equation top-level definition, not
-- only from its first equation.
--
-- When the first equation uses a wildcard (@_@) for an argument and a later
-- equation names it (e.g. @n@), specs of @where@- or @let@-bound helpers in
-- that later equation must still be able to mention @n@.
{-# LANGUAGE ScopedTypeVariables #-}
{-@ LIQUID "--no-termination" @-}
module LocalSpecMultiEqBinders where

{-@ type Bounded B = { m : Int | m < B } @-}

-- | 'step' increments every element of a list bounded by @b@, yielding a list
-- bounded by @b + 1@.  The local helper @go@ is specified using the binder
-- @n@ that only appears in the /second/ equation; the first equation uses a
-- wildcard (@_@).
{-@ step :: b : Int -> [Bounded b] -> [Bounded (b + 1)] @-}
step :: Int -> [Int] -> [Int]
step _ [] = []
step n ms = go ms
  where
    {-@ go :: [Bounded n] -> [Bounded (n + 1)] @-}
    go :: [Int] -> [Int]
    go []     = []
    go (x:xs) = (x + 1) : go xs

-- | Same scenario expressed with a @let@ binding instead of @where@.
{-@ stepLet :: b : Int -> [Bounded b] -> [Bounded (b + 1)] @-}
stepLet :: Int -> [Int] -> [Int]
stepLet _ [] = []
stepLet n ms =
  let {-@ go :: [Bounded n] -> [Bounded (n + 1)] @-}
      go :: [Int] -> [Int]
      go []     = []
      go (x:xs) = (x + 1) : go xs
  in go ms
