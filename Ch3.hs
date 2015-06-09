{- Chapter 3:: Syntax in Functions -}

-- Haskell uses pattern matching to define how a function will return
-- given different inputs that satisfy the type signature.

lucky :: Int -> String
lucky 7 = "Lucky number 7!"
lucky n = "Sorry pal, you're all out of luck!"

-- Patterns are checked and matched from top to bottom.
-- Any pattern supplied starting with (or only consisting of)
-- a lower case letter will act as a catch all and should be
-- specified at the end of the function definition.

sayMe :: Int -> String
sayMe 1 = "one"
sayMe 2 = "two"
sayMe 3 = "three"
sayMe 4 = "four"
sayMe 5 = "five"
sayMe x = "That's not between 1 and 5!"

-- Another use for this is to define recursive patterns
-- Here is another implementation of the factorial function:

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)

-- Note again that the parens are just to ensure operator precedence
-- as function application is the most tightly binding.

-- It is possible to skrew this up if you do not supply the correct
-- patterns when you define your function:

fail :: Char -> String
fail 'a' = "Albert"
fail 'b' = "Bob"

-- If we try to call "fail 'c'" then Haskell will complain and tell us
-- that we have non-exhaustive patterns in our function.
-- SPECIFY A CATCH ALL! (Even if this is just to raise an exception)

{- Pattern matching with tuples -}
-- Remember:: the LENGTH of a tuple is part of its type!

addVectors :: (Double, Double) -> (Double, Double) -> (Double, Double)
addVectors (x1, x2) (y1, y2) = (x1 + x2, y1 + y2)

-- We can also define our own version for 'fst' and 'snd' which only
-- work on pairs:

first :: (a,b,c) -> a
first (x,_,_) = x

second :: (a,b,c) -> b
second (_,y,_) = y

third :: (a,b,c) -> c
third (_,_,z) = z

-- NOTE:: the '_' character is used again to represent a value that we don't care about in a pattern.

-- When working with lists we can use the x:xs idiom to capture the first element and the rest of the list
-- HOWEVER:: patterns including the ':' character will not match the empty list...

head' :: [a] -> a
head' []    = error "You fail"
head' (x:_) = x

-- NOTE:: the 'error' function will take the supplied string and CRASH THE PROGRAM using that string
-- as the runtime error...use it sparingly!

tell :: (Show a) => [a] -> String
tell []      = "That there is an empty list..."
tell [x]     = "One element: " ++ show x
tell [x,y]   = "Two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This one is long! I don't want to look..."

-- We know that this function will be safe to use as it matches all possible cases: [], single element,
-- two element and any element lists.

-- Haskell also allows you to talk about complicated patterns in a simplified way through the use of
-- 'as-patterns'. To use this, preceed a pattern with [name]@

firstLetter :: String -> String
firstLetter ""         = "Oops! Thats the empty string..."
firstLetter all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

-- NOTE:: without the use of the as-pattern we would have had to replace the 'all' in the result
-- with (x:xs). Not too bad here but with a more complicated pattern it will get messy!
-- Secondly, when concatinating the strings we needed to specify [x] not x as x would be a type error!

{- Guards -}
-- Pattern matching is used to check if the values passed to our function are constructed in a particular
-- way. Guards are used to to check if a property of the passed values is true or false.

bmiTell :: Double -> String
bmiTell bmi
    | bmi <= 18.5 = "Underweight!"
    | bmi <= 25.0 = "Looking good!"
    | bmi <= 30.0 = "Overweight!"
    | otherwise   = "Obese!..."

-- Note that most often you will need the otherwise clause, again as a catch all.
-- Again, Haskell will "fall through" the specified checks and select the first on that
-- returns true.
-- This is similar to a large if/elif/else statement in Python (only more readable!)


-- If we want to store an intermediate result or define a varible local to a function
-- we can use the 'where' keyword as shown here::
bmiTell' :: Double -> Double -> String
bmiTell' weight height
    | bmi <= skinny     = "Underweight!"
    | bmi <= normal     = "Looking good!"
    | bmi <= overweight = "Overweight!"
    | otherwise         = "Obese!..."
    where bmi        = weight / height ^ 2
          skinny     = 18.5
          normal     = 25.0
          overweight = 30.0

-- NOTE:: The where clause comes AT THE END of our list of guards and all of the definitions
--        are aligned with one another. If not, Haskell will get confused...
-- When working with pattern matching, a where clause will ONLY apply to the pattern it is defined
-- under (i.e. the last pattern) to make use of definitions like we have done above requires a global
-- definition (this looks exactly the same as a function definition).

globallyDefined :: String
globallyDefined = "This string is defined for all functions in this file!"


initials :: String -> String -> String
initials fname sname = [f] ++ ". " ++ [s] ++ "."
    where (f:_) = fname
          (s:_) = sname

-- The where clause can also be used to define a local function!
calcBmis :: [(Double, Double)] -> [Double]
calcBmis xs = [bmi w h | (w,h) <- xs]
    where bmi  weight height = weight / height ^ 2


-- Haskell also has a 'let' expression that works in a similar way to 'where'
-- The difference is that 'let' IS an expression and can be used as such:
letDemo = 14 * (let x = 5 in 3 * x)

calcBmis' :: [(Double, Double)] -> [Double]
calcBmis' xs = [bmi | (w,h) <- xs, let bmi = w / h ^ 2]


{- Case expressions -}
-- Pattern matching is a very powerful concept but it ONLY works within the definition
-- of a function. Case expressions allow us to perform something similar anywhere that
-- an expression would be valid.
-- The general syntax is:
-- case EXPRESSION of PATTERN -> RESULT
--                    PATTERN -> RESULT
--                    ...

describeList :: [a] -> String
describeList ls = "This list is " ++ case ls of []  -> "empty."
                                                [x] -> "a singleton list."
                                                xs  -> "a longer list."

-- Note again that each patter is aligned as with 'where'.
