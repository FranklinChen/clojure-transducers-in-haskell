{-
  Clojure transducers translated into Haskell.

  http://blog.cognitect.com/blog/2014/8/6/transducers-are-coming

  Based on Rich Hickey's preliminary Haskell version at
  http://www.reddit.com/r/haskell/comments/2cv6l4/clojures_transducers_are_perverse_lenses/
-}

{-# LANGUAGE Rank2Types #-}

-- For example using Vector instead of list
import qualified Data.Vector as V

-- Left reduce
type Reducer a r = r -> a -> r

-- Here's where the rank-2 type is needed
type Transducer a b = forall r . Reducer a r -> Reducer b r

-- Left fold
class Foldable t where
  fold :: Reducer a r -> r -> t a -> r

class Conjable f where
  empty :: f a
  conj :: Reducer a (f a)

mapping :: (b -> a) -> Transducer a b
mapping f xf r a = xf r (f a)

filtering :: (a -> Bool) -> Transducer a a
filtering p xf r a = if p a then xf r a else r

flatmapping :: Foldable f => (a -> f b) -> Transducer b a
flatmapping f xf r a = fold xf r (f a)

-- I changed Rich Hickey's code to be more general than just list
-- but accept anything Conjable
xlist :: (Foldable f, Conjable f) => Transducer a b -> f b -> f a
xlist xf = fold (xf conj) empty

-- build any old Foldable function with its transducer, all the same way
xmap :: (Foldable f, Conjable f) => (a -> b) -> f a -> f b
xmap f = xlist $ mapping f 

xfilter :: (Foldable f, Conjable f) => (a -> Bool) -> f a -> f a
xfilter p = xlist $ filtering p

xflatmap :: (Foldable f, Conjable f) => (a -> f b) -> f a -> f b
xflatmap f = xlist $ flatmapping f

-- Stuff specialized to lists.
-- To use another type, just make it a Foldable and Conjable.
instance Foldable [] where
  fold = foldl

-- for exposition only, yes, conj is gross for lazy lists
-- in Clojure conj and left folds dominate
instance Conjable [] where
  empty = []
  conj xs x = xs ++ [x]

-- Note: the type does not say anything about Foldable or Conjable,
-- even though the implementation just happens to use a list!
xform :: Transducer Integer Integer
xform = mapping (+ 1) . filtering even . flatmapping (\x -> [0 .. x])

-- Again, this can munge anything Foldable and Conjable, not just a list.
munge :: (Foldable f, Conjable f) => f Integer -> f Integer
munge = xlist xform

-- munge a list
-- [0,1,2,0,1,2,3,4,0,1,2,3,4,5,6]
example1 :: [Integer]
example1 = munge [1..5]

-- Implement Foldable, Conjable type classes for Vector
instance Foldable V.Vector where
  fold = V.foldl

instance Conjable V.Vector where
  empty = V.empty
  conj = V.snoc

-- return a vector rather than a list; note the fact that munge actually
-- internally uses a list
example2 :: V.Vector Integer
example2 = munge $ V.enumFromN 1 5
