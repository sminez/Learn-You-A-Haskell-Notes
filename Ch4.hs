{- Chapter 4:: Recursion -}
-- Some examples of recursively defined functions

zip' :: [a] -> [b] -> [(a,b)]
zip' _ []          = []
zip' [] _          = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys


elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
    | a == x    = True
    | otherwise = elem' a xs


-- NOTE:: This version of quisort uses the first element of the list as the pivot
-- which it TERRIBLE when the list is already in order...
quickSort :: (Eq a, Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
    let smallerOrEqual = [a | a <- xs, a <= x]
        larger         = [a | a <- xs, a > x]
    in quickSort smallerOrEqual ++ [x] ++ quickSort larger


-- Find the middle element of a list, preferring the left of centre for an even length list.
middleL :: [a] -> a
middleL xs@(_:_:_:_) = middleL(tail(init(xs)))
middleL [x,y]        = x
middleL [x]          = x
