{- Chapter 2 :: Believe the Type -}

-- Haskell will automatically derive a type via type inference for every function we define.
-- As such, user specified types are their to inform about the use of a function and in some
-- cases, restrict the allowed inputs.
removeNonUpper :: [Char] -> [Char]
removeNonUpper s = [ c | c <- s, elem c ['A'..'Z']]

tripleAdd :: Int -> Int -> Int -> Int
tripleAdd x y z = x + y + z

-- Note that there is a difference in Haskell between 'Int' and 'Integer':
-- Int is limited to the word size of the machine executing the program while
-- Integer is unbounded and can take ANY integer value (Though very large values may crash).
-- >> For fun, try runnning factorial 1000000
factorial :: Integer -> Integer
factorial n = product [1..n]

-- For the next two functions, note the difference in the output when we switch
-- from floats to double precision floats.
circ :: Float -> Float
circ r = 2 * pi * r

circ' :: Double -> Double
circ' r = 2 * pi * r


{- Type classes -}
-- In Haskell, Type classes are sets of types that all share a common property in the same
-- way that types are sets of values that share common property.
-- >> i.e. 1,2,3 are of type Int while Int,Float,Double are of the type class Num.
-- If a Type implements a type class then it needs to support the operations defined for that
-- type class::

-- Eq       -> Testing for equality:: ==, /=
-- Ord      -> Ordering of elements:: <, >, >=, <=,
-- Show     -> Can be represented as a string
--             e.g. show :: Show a => a -> String
-- Read     -> Can be converting from string to a value
--             NOTE:: Read must be given either a type or a use case to infer from
--             e.g. read :: Read a => String -> a         (USE: read "2" :: Float --> 2.0)
--             Without this we do not know the type of a!
-- Enum     -> Instances are sequentially ordered. this allows them to be used in ranges
--             This also means that there is a definate successor and predecessor for each value
-- Bounded  -> There are lower and upper bounds:: minBound, maxBound
-- Num      -> Acts like a number. (NOTE:: must also be an instance of Show and Eq)
-- Floating -> Nums representing using floating point numbers (Float and Double)
-- Integral -> Nums that represent whole numbers (Int and Integer)
