{- Chapter 5:: Higher Order Functions -}

-- In Haskell, functions are first class citizens. This means that they can
-- be passed as paramaters to and returned from other functions.
-- ALL functions in Haskell are automatically Curried and can be partially
-- applied in order to create new functions with fewer arguments. The following
-- are several examples of how to make use of this.
-- NOTE:: In the OOP paradigm, classes and inheritance are used to share /
-- reuse functionality: in functional programming we use higher order functions
-- for some of the same purposes.


{- Reading type signatures correctly -}

-- Consider the following simple function:
mult3 :: Int -> Int -> Int -> Int
mult3 x y z = x * y * z

-- It looks like it takes three Ints as paramaters and then returns an Int.
-- Actually, the arrow notation always brackets to the right and under the
-- hood the correct way to read the type signature is as follows:
mult3' :: Int -> (Int -> (Int -> Int))
mult3' x y z = x * y * z

-- We take an Int and return a function, that takes an Int and returns a function,
-- that takes an Int and returns an Int...!
-- This may seem clearer if we partially apply this function to create another:
mult2with5 = mult3 5

-- Now, this function will take TWO arguments and return an Int. REMEMBER: under
-- the hood this new function takes an Int and returns a function that will take
-- an Int and return an Int... o_0

-- Infix functions can be partially appplied by using Sections:
divideBy10 :: (Floating a) => a -> a
divideBy10 = (/10)


{- Passing functions as parameters: -}

-- Here, the brackets are required to create a left association: applyTwice takes
-- a function that takes an a and returns an a along with an a to apply it to. It
-- Then applies the function twice and returns an a.
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _          = []
zipWith' _ _ []          = []   -- If either list is [] then the result is []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys


{- Commonly used VERY USEFUL higher order functions -}

-- Swap the order of arguments for a function
flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f = g
    where g x y = f y x


-- Take a function on values and apply it to a list of values
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map f xs


-- Return only values satisfying a given predicate (same as the internals of a list comprehension)
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
    | p x       = x : filter p xs
    | otherwise = filter p xs



{- Lambdas -}
-- Lambdas are anonymous functions that are useful when you only want to call a function once and don't
-- want to define it gloabally (taking up a name in the namespace).
-- The following are equivalent:
--    map (+3) [1,2,3,4,5]
--    map (\x -> x + 3) [1,2,3,4,5]
-- For simple functions that already have a definition this is obviously daft but for more complex single
-- use functions this can be very useful.
-- NOTE:: The syntax is    (\[arguments] -> [function on arguments])
-- The parens stop the lambda expression containing EVERYTHING following it on the line.
lambdaEx = zipWith (\a b -> (a * 30 + 3) / b) [5,4,3,2,1] [1,2,3,4,5]

-- You can also pattern match inside of a lambda, BUT...if this fails it causes a runtime error and crash!
lambdaEx2 = map (\(a,b) -> a+b) [(1,2), (3,4), (5,6)]


-- Example: Collatz sequences:: how many Collatz sequences seeded with the numbers 1..100 are longer than 15 terms?
-- From a given starting number, create a list where the next number is determined by whether the previous
-- is odd or even. All chains stop at 1.
-- Even -> divide by 2
-- Odd  -> multiply by 3 and add 1
chain :: Integer -> [Integer]
chain 1 = [1]
chain n
    | even n = n : chain (div n 2)
    | odd n  = n : chain (n*3 + 1)

numLongChains :: Int
numLongChains = length ((filter (\xs -> length xs > 15)) (map chain [1..100]))


{- Folds -}
-- Folds are the Haskell generalisation for taking a list of values and combining them in some way to produce a single
-- answer. They all take a binary function (two arguments) and a starting value known as an accumulator. Lists can be folded
-- from the left (foldl) or from the right (foldr) which WILL affect the result for some operators!! (e.g. (-))

-- One way to think of folds is as repeated function application to successive elements of a list, carrying forward the accumulator:
--    foldl f acc [1,2,3] == f (f (f acc 1) 2) 3
--    foldr f acc [1,2,3] == f 1 (f 2 (f 3 acc))
--
-- For f == (+):
--    foldl (+) 0 [1,2,3] = ((0+1)+2)+3
--    foldr (+) 0 [1,2,3] = 0+(1+(2+3))


foldSum :: (Num a) => [a] -> a
foldSum xs = foldl (\acc x -> acc + x) 0 xs

-- Or with Currying...
foldSum' :: (Num a) => [a] -> a
foldSum' = foldl (+) 0


rFoldMap :: (a -> b) -> [a] -> [b]
rFoldMap f xs = foldr (\x acc -> f x : acc) [] xs

lFoldMap :: (a -> b) -> [a] -> [b]
lFoldMap f xs = foldl (\acc x -> acc ++ [f x]) [] xs

-- Note that out of the two of these, rFoldMap will be faster due to the use of cons (:) rather than append (++)
-- in rFoldMap (+3) [1,2,3] we take the last element of the list (3), add 3 to it and cons it to the accumulator
-- (3+3) : [] --> 6:[] == [6]. We then take the next element (2) and do the same: (2+3) : [6] --> 5:[6] == [5,6] etc.
-- Remember, the cons operator PREpends to a list and the apppend operator APpends. As Haskell lists are linked list
-- nodes, cons simply adds an extra node to the front of the list while (++) will have to re-write EVERY element of
-- the list as the creation of a new tail element will invalidate ALL pointers to the previous values.

-- Here we define a starting value for the accumulator and then modify it based on a boolean check.
foldElem :: (Eq a) => a -> [a] -> Bool
foldElem y ys = foldr (\x acc -> if x == y then True else acc) False ys


-- Folding and infinite lists
-- Infinite lists are fairly common in Haskell programs and the idea of successively applying a function to EVERY
-- element in a list may look like it will cause problems with this. However, for some functions this is perfectly ok!

and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs

-- This function will return True iff all values in the list are True. Using the reasoning we had before:
-- and' [True, False, True] will be evaluated as follows:
--    True && (False && (True && True)) == False.
-- So far so good. But what about: "and' (repeat False)"?
-- It looks like it should be infinite: False && (False && (False...
-- Here, Haskell's laziness comes to the rescue!
--     (&&) :: Bool -> Bool -> Bool
--     True && x  = x
--     False && _ = False
-- As ANYTHING paired with a False returns a False, Haskell stops the computation and returns False at the
-- FIRST False value that it encounters!


{- Scans -}
-- A scan is similar to a fold but instead of returning a value it returns a list of the intermediate values
-- during the computation. They are used to monitor the progress of a function that can be implemented as a fold.
--
-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
--
-- e.g. scanl (+) 0 [1,2,3] returns [0,1,3,6]
--      scanr (+) 0 [1,2,3] returns [6,5,3,0]
-- Note that the original accumulator value is included in the output as well so the resulting list is one
-- element longer than the original.

-- The following is a nice trick to allow the use of a left fold or left scan with the cons operator.
-- NOTE:: without this, the computation will fail with a type error regarding infinite types?!?!!
revBuildUp :: [a] -> [[a]]
revBuildUp xs = scanl (flip(:)) [] xs


-- A toy application of scan --
-- The following code is a pair of functions that we will use to find the answer to the following question:
-- How many elements does it take for the sum of the square roots of the natural numbers to exceed a given value?

sqrtSums :: (Ord a, Floating a, Enum a) => a -> [a]
sqrtSums n = takeWhile (< n) (scanl1 (+) (map sqrt [1..]))

howManySqrts :: (Ord a, Floating a, Enum a) => a -> Int
howManySqrts n = length (sqrtSums n) + 1

-- NOTE:: the argument passed to these is type variable under the constraints listed as we are using it in the
-- comparison with takeWhile. We could restrict it further be here we allow the implementer to specify a stricter
-- data type if they wish or we can create a stricter version later if needed.
-- In general, this is the preferred way to define functions: as polymorphic as possible to begin with and then
-- restrict them later if needed.


{- The function application operator ($) -}
-- ($) :: (a -> b) -> a -> b
-- f $ x = f x

-- While this function appears to be entirely useless it is actually quite helpful in expressions that would otherwise
-- have a large amount of parens. While function application has a really high precedence, $ has the lowest AND is right
-- associative rather than left associative.

-- Where to use it?
-- Take the following expression:
--     sqrt 3 + 4 + 5
-- Due to Haskell's function precedence, this will evaluate as (sqrt 3) + 4 + 5
-- To get sqrt (3 + 4 + 5) we can write either that (<--) OR:
--     sqrt $ 3 + 4 + 5
-- You can think of $ as opening a set of parens that close at the end of the line.

-- In addition to removing parens, ($) can also be used to treat function application as a function itself...
--     map ($ 3) [(4+), (10*), (^2), sqrt]
-- Here, ($) will take a function and apply it to 3.


{- Function composition (.) -}
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- f . g = \x -> f (g x)

-- This is exactly the same as mathematical function composition (the dot is supposed to look like a circle...(f o g))
-- The following are equivalent though the compositional code is arguably clearer than the lambda based version.
negLambda :: (Num a) => [a] -> [a]
negLambda xs = map (\x -> negate (abs x)) xs

negComp :: (Num a) => [a] -> [a]
negComp xs = map (negate . abs) xs

-- This is particularly useful for defining composite functions on the fly:
-- The equivalent to map (\xs -> negate (sum (tail xs))) ys    is:
compEx :: (Num a) => [[a]] -> [a]
compEx xs = map (negate . sum . tail) xs

-- This code is daft: it finds the sum of the tail of a list of Nums and negates the result...

-- NOTE:: to use function composition we must have functions that take a SINGLE argument: if not
-- you will need to partially apply the function in question until it requires only one argument.


{- Point-free style -}
-- Thanks to Currying and partial application, we can actually perform algebraic simplification
-- on our code and cancel out arguments within function definitions. This is known as "point-free
-- style".

-- From before:
sumWithArgs :: (Num a) => [a] -> a
sumWithArgs xs = foldl (+) 0 xs

pointFreeSum :: (Num a) => [a] -> a
pointFreeSum = foldl (+) 0

-- Now for a crazy one!
crazy :: (RealFrac b, Integral c, Floating b) => b -> c
crazy x = ceiling (negate (tan (cos (max 50 x))))

-- This is VERY noisy with the parens but we can't just remove the x this time...function
-- composition to the rescue!

crazyComp :: (RealFrac b, Integral c, Floating b) => b -> c
crazyComp = ceiling . negate . tan . cos . max 50

-- Now, the argument we pass in will pass through the function from right to left as we intend.
