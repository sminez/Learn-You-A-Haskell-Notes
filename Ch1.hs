{- Chapter 1:: Starting out -}

{- Operators
True && False -- Boolean AND
False || True -- Boolean OR
not False     -- Boolean NOT
5 == 5        -- Test for equality
5 /= 7        -- Test for inequality
-}

{- Prelude functions
succ :: Enum a => a -> a          -- return the "next" value after the one provided
min :: Ord a => a -> a -> a       -- return the minimum of TWO arguments
max :: Ord a => a -> a -> a       -- return the maximum of TWO arguments
div :: Integral a => a -> a -> a  -- perform integral division on TWO arguments (discard fractional part)
head :: [a] -> a                  -- return the first element of a list
tail :: [a] -> [a]                -- return every element BUT the first
last :: [a] -> a                  -- return the last element of a list
init :: [a] -> [a]                -- return every element BUT the last
length :: [a] -> Int              -- return the length of a list
null :: [a] -> Bool               -- True if list is [], otherwise False
reverse :: [a] -> [a]             -- reverse the order of a list
take :: Int -> [a] -> [a]         -- return the first (Int) elements of a list. If (Int)>len[a] then return [a]
drop :: Int -> [a] -> [a]         -- remove the first (Int) elements of a list and return the rest. If (Int)>len[a] then return []
maximum :: Ord a => [a] -> a      -- return the 'largest' value in the list. (for [Char], lower case > upper case)
minimum :: Ord a => [a] -> a      -- return the 'smallest' value in the list
elem :: Eq a => a -> [a] -> Bool  -- return True if the supplied value is in the list, else False
   -- Arguably easier to read using the back tick trick:: x `elem` [x,y,z] rather than elem x [x,y,z]
cycle :: [a] -> [a]               -- create an infinite list by repeating the given list
replicate ::: Int -> a -> [a]     -- create a list of the given item repeated (Int) times
repeat :: a -> [a]                -- create an infinite list by repeating the given element
mod :: Integral a => a -> a -> a  -- mod 17 5 will return the remainder of 17 when divided by 5 (17 `mod` 5)
-}

{- Some functions -}
-- All Haskell functions take a SINGLE argument. If it looks otherwise then multiple functions are being
-- composed together using intermediate results to create the final output.

doubleMe :: Num a => a -> a
doubleMe x = x + x

doubleUs :: Num a => a -> a -> a
doubleUs x y = doubleMe x + doubleMe y


-- Here we can use an 'if, then, else' EXPRESSION to have conditional evluation of an argument.
-- Note that the 'else' line is ALWAYS required as a Haskell function must always return a value.
doubleSmallNumber :: (Ord a, Num a) => a -> a
doubleSmallNumber x = if x > 100
                      then x
                      else x * 2
-- this last clause can also be a one liner:: 'x = if x > 100 then x else x * 2'


{- Texas Ranges-}
-- NOTE:: leaving off the end of the range will produce an infinite list [useful when used correctly]
twos = [2,4 .. 20]            -- this will produce [2,4,6,8,10,12,14,16,18,20]
decr = [5,4 .. 1]             -- [5,4,3,2,1]
thirts = take 24 [13, 26..]   -- create an infinite list of the multiples of 13 and then take the first 24 elements

{- List Comprehensions -}
-- All list comprehensions in Haskell can be read in the following way::
--     [(representation in new list) | (variable for use in representation) <- (source of values for variable)]
-- The | symbol operates in the same way as a Unix pipe:: we are passing in values from the right to our expression on the left

twos' = [x*2 | x <- [1..10]]  -- create the previous list using a list comprehension

-- Here the source of values for the primary list comrehension is, itself, a list comprehension.
twoSquares = [x^2 | x <- [n*2 | n <- [1..10]]]

-- We can also include predicates to filter values::
-- These are given AFTER the source of values and are preceded and separated by commas
bigTwos = [x*2 | x <- [1..10], x*2 > 12, x*2 < 20]

boomBang xs = [ if x < 10 then "Boom!" else "Bang!" | x <- xs, odd x] -- note that 'odd' and 'even' return a Bool if their argument matches

-- It is also possible to draw values from multiple lists
xPlusY :: Num n => [n] -> [n] -> [n]
xPlusY xs ys = [x+y | x <- xs, y <- ys] -- NOTE:: ALL possible combinations will be provided in the output

-- Finding some right-angled triangles
trigons :: (Num n, Eq n, Enum n)  => n -> [(n,n,n)]
trigons x = [(a,b,c) | c <- [1..x], b <- [1..c], a <- [1..b], (a^2 + b^2 == c^2)]
