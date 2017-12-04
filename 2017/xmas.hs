import System.Environment
import Data.Char
import Data.List
import System.FilePath

inputDir = "/home/mlehmann/study/adventOfCode/2017/inputs/"
days = [ day1 ]

day1Main = do
    c <- readFile $ inputDir </> "day1.txt"
    print $ day1part1 c
    print $ day1part2 c

-- listNumbers = map (read :: String -> Int)
--               . map (\ x -> [x])
  --             . filter isDigit $ str

day1part1 str = let listNumbers = map (read :: String -> Int)
                             . map (\ x -> [x])
                             . filter isDigit $ str
           in sum
              . map (\ (a,b) -> a)
              . filter (uncurry (==))
              . zip listNumbers $ ( tail $ cycle listNumbers )

day1par2 str = 

rInt :: String -> Int
rInt = read

main = do
    [ day ] <- getArgs
    let callDay = ( [ day1Main ] !!) . (+ (-1))
    callDay $ rInt day


-- results
-- day01_01 1031
