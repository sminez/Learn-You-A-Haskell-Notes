{- Chapter 6:: Modules -}

-- Importing in Haskell is like from [x] import * in python by default.
-- To use a function from an imported function simply call it as if it
-- had been defined in the file that you are working in:
-- e.g. to use the Data.List 'group' function that groups list elements
-- into sublists we would type:
--    group [1,1,1,1,1,2,2,2,2,3,3,3]

import Data.List

-- This will import ALL functions from the Data.List module and add them
-- to the current namespace.
-- NOTE:: This WILL cause naming clashes if there are conflicts.

-- To work around this you can do a qualified import:

import qualified Data.Map

-- Now to use a function we need to type Data.Map.[function name]
-- As this is rather verbose we can also do an "import as":

import qualified Data.Char as C

-- Now to use an imported function we simply type C.[function name]


-- Example >> Caeser cypher!
encode :: Int -> String -> String
encode offset msg = map (\c -> C.chr $ C.ord c + offset) msg

-- Now we simply reuse the encode function by negating the offset
decode :: Int -> String -> String
decode offset msg = encode (negate offset) msg


{- On Strict Left Folds -}
-- As we have seen before, folds are a  very useful abstraction to use
-- for a wide variety of problems. However, due to Haskell's laziness
-- folding a very llarge list can lead to a stack overflow error as the
-- actual computation is only carried out when the END of the list is
-- reached!
-- For folding very large lists we can use a stricter version of the fold
-- function that is found in the Data.List module: foldl'
-- NOTE:: the notation of ' to denote a stricter version of a function is
-- commmonplace in Haskell libraries.
-- foldl' will evaluate the result after EVERY element (so it is slower but
-- uses less memory)


