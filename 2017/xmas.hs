import System.Environment
import Data.Char
import Data.List
import System.FilePath

inputDir = "/home/mlehmann/study/adventOfCode/2017/inputs/"
days = [ day1Main ]

day1Main = do
    c <- readFile $ inputDir </> "day1.txt"
    -- print $ day1part1 c
    print $ day1part2 c

-- DAY1 Start
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

rInt :: String -> Int
rInt = read

main = do
    [ day ] <- getArgs
    let callDay = ( [ day1Main ] !!) . (+ (-1))
    callDay $ rInt day


-- results
-- day01_01 1031
-- day01_02 1080
