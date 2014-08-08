-- Rich Hickey's code, verbatim from
-- http://www.reddit.com/r/haskell/comments/2cv6l4/clojures_transducers_are_perverse_lenses/

-- Transducers in Haskell

mapping :: (b -> a) -> (r -> a -> r) -> (r -> b -> r)
mapping f xf r a = xf r (f a)

filtering :: (a -> Bool) -> (r -> a -> r) -> (r -> a -> r)
filtering p xf r a = if p a then xf r a else r

flatmapping :: (a -> [b]) -> (r -> b -> r) -> (r -> a -> r)
flatmapping f xf r a = foldl xf r (f a)

-- for exposition only, yes, conj is gross for lazy lists
-- in Clojure conj and left folds dominate
conj xs x = xs ++ [x]
xlist xf = foldl (xf conj) []

-- build any old list function with its transducer, all the same way
xmap :: (a -> b) -> [a] -> [b]
xmap f = xlist $ mapping f 

xfilter :: (a -> Bool) -> [a] -> [a]
xfilter p = xlist $ filtering p

xflatmap :: (a -> [b]) -> [a] -> [b]
xflatmap f = xlist $ flatmapping f

-- again, not interesting for lists, but the same transform 
-- can be put to use wherever there's a step fn

xform :: (r -> Integer -> r) -> (r -> Integer -> r)
xform = mapping (+ 1) . filtering even . flatmapping (\x -> [0 .. x])


print $ xlist xform [1..5]
-- [0,1,2,0,1,2,3,4,0,1,2,3,4,5,6]
