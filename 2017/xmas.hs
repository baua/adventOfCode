import Control.Monad
import System.Environment
import Data.Char
import Data.List
import System.FilePath

inputDir = "/home/mlehmann/study/adventOfCode/2017/inputs/"
days = [ day1Main, day2Main, day3Main, day4Main ]

rInt :: String -> Int
rInt = read

noDuplicates [] = True
noDuplicates xs
    | nub xs == xs  = True
    | otherwise     = False

-- DAY4 Start
day4Main = do
    content <- readFile $ inputDir </> "day4.txt"
    let linesOfFile = map words $ lines content
    print $  "part1=" ++ show (day4part1 linesOfFile)
    print $  "part2=" ++ show (day4part2 linesOfFile)

day4part1 xs = length
                $ filter (==True)
                $ map noDuplicates xs
day4part2 xs = length
                $ filter (==True)
                $ map noDuplicates
                $ map (map sort) xs
-- DAY4 End

-- DAY3 Start
day3Main = do
    let magicNumber=289326
    print "hmmm"
    -- print $  "part1=" ++ show (day2part1 linesOfFile)
    -- print $  "part2=" ++ show (day2part2 linesOfFile)

-- DAY3 End
-- DAY2 Start
day2Main = do
    --let content ="5 9 2 8\n9 4 7 3\n3 8 6 5\n"
    content <- readFile $ inputDir </> "day2.txt"
    let linesOfFile = map (map rInt ) $ map words $ lines content
    print $  "part1=" ++ show (day2part1 linesOfFile)
    print $  "part2=" ++ show (day2part2 linesOfFile)

rem' :: Int -> Int -> [(Int, Int)]
rem' x y | x == y = []
    | x `rem` y == 0 = [(x, y)]
    | otherwise = []

evenDivider xs = head . join $ (rem' <$> xs <*> xs)
day2part2 xs = sum
                . map (\ (a,b) -> a `div` b)
                $ map evenDivider
                $ map reverse
                $ map sort xs

day2part1 xs = sum
                . map (\ (a,b) -> (a + (-b)))
                $ zip (map maximum xs) (map minimum xs)
-- DAY2 End

-- DAY1 Start
day1Main = do
    input <- readFile $ inputDir </> "day1.txt"
    print $ "part1=" ++ show (day1part1 input)
    print $ "part2=" ++ show (day1part2 input)

listNumbers = map (read :: String -> Int)
               . map (\ x -> [x])
               . filter isDigit

sumUpEquals = sum
              . map (\ (a,b) -> a)
              . filter (uncurry (==))

day1part1 str = let numbers = listNumbers str
           in sumUpEquals . zip numbers $ ( tail $ cycle numbers )

day1part2 str = let numbers = listNumbers str
                    halfNumbers = (div (length numbers) 2 )
           in sumUpEquals . zip numbers $ drop halfNumbers $ cycle numbers

-- DAY1 End

main = do
    [ day ] <- getArgs
    let callDay = ( days !!) . (+ (-1))
    callDay $ rInt day


-- results
-- day04_01 386
-- day04_02 208
-- day03_01
-- day03_02
-- day02_01 44887
-- day02_02 242
-- day01_01 1031
-- day01_02 1080
