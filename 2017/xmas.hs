import Control.Monad
import System.Environment
import Data.Char
import Data.List
import Data.Ord
import Debug.Trace
import System.FilePath

inputDir = "/home/mlehmann/study/adventOfCode/2017/inputs/"
days = [ day1Main, day2Main, day3Main, day4Main, day5Main, day6Main]

rInt :: String -> Int
rInt = read

noDuplicates [] = True
noDuplicates xs
    | nub xs == xs  = True
    | otherwise     = False

-- DAY6 Start -={
day6Main = do
    content <- readFile $ inputDir </> "day6.txt"
    --let content="0 2 7 0"
    let linesOfFile = map words $ lines content
        (last,count) = day6part1 linesOfFile
    print $  "part1=" ++ show count ++ ":" ++ show last
    --print $  "part1=" ++ show (day6part1 linesOfFile)

-- MJs function
solution2 xs n =
  let len = length xs
  in zipWith (+) xs
                 ( map sum . Data.List.transpose
                           . map (take len . (++ repeat 0))
                           . takeWhile (not . null)
                           . iterate (snd . splitAt len)
                           $ (replicate n 1) )

redistributeMax :: [ Int ] -> [ Int ]
redistributeMax xs = let (max,pos) = maximumBy (comparing fst ) (zip xs [0..])
                         nl = take (length xs - 1) $ drop (pos+1) $ cycle xs
                     in solution2 ([0]++nl) max

runUntilRepeat :: [Int] -> [[Int]] -> Int -> ([Int],Int)
runUntilRepeat current states counter
    | counter == 1 = (current, counter )
    | elem current states = ( current, counter )
    | otherwise = runUntilRepeat (redistributeMax current) (states++[current]) (counter+1)

day6part1 xs = runUntilRepeat (map rInt $ join xs) [] 0
--day6part1 xs = map rInt $ join xs

-- }=-

-- DAY5 Start -={
day5Main = do
    content <- readFile $ inputDir </> "day5.txt"
    --let content="0\n3\n0\n1\n-3"
    let linesOfFile = map words $ lines content
    --print $  "part1=" ++ show (day5part1 linesOfFile)
    print $  "part2=" ++ show (day5part2 linesOfFile)

addToNthElement :: [ Int ] -> Int -> Int -> [ Int ]
addToNthElement xs pos value =
    let (ys,zs) = splitAt pos xs
    in ys ++ [(xs !! pos + value )] ++ tail zs

day5 :: Int -> Int -> [ Int ] -> ( Int, Int, [Int] )
day5 steps pos xs
    | pos >= length xs  = ( steps, pos, [] )
    | otherwise         = day5 (steps + 1) (pos + (xs !! pos)) (addToNthElement xs pos 1)

day5_2 :: Int -> Int -> [ Int ] -> ( Int, Int, [Int] )
day5_2 steps pos xs
    | pos >= length xs  = ( steps, pos, [] )
    | xs !! pos >= 3  &&  pos < length xs = day5_2 (steps + 1) (pos + (xs !! pos)) (addToNthElement xs pos (fromIntegral (-1)))
    | otherwise         = day5_2 (steps + 1) (pos + (xs !! pos)) (addToNthElement xs pos 1)

day5part1 xs = day5 0 0 $ map rInt $ join xs
day5part2 xs = day5_2 0 0 $ map rInt $ join xs

-- }=-

-- DAY4 Start -={
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
-- }=-

-- DAY3 Start -={
day3Main = do
    let magicNumber=289326
    print "hmmm"
    -- print $  "part1=" ++ show (day2part1 linesOfFile)
    -- print $  "part2=" ++ show (day2part2 linesOfFile)

-- }=-

-- DAY2 Start -={
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
-- }=-

-- DAY1 Start -={
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

-- }=-

main = do
    [ day ] <- getArgs
    let callDay = ( days !!) . (+ (-1))
    callDay $ rInt day


-- results
-- day05_01 373160
-- day05_02 26395586
-- day04_01 386
-- day04_02 208
-- day03_01 373160
-- day03_02
-- day02_01 44887
-- day02_02 242
-- day01_01 1031
-- day01_02 1080
