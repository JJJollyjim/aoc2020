import           AOC
import           Data.List (group, sort)

main = runAOC progA progB

-- Part A

progA i = let jolts = 0:(sort $ map read $ lines i)
              diffs = diff jolts
  in show $ (length $ filter (==1) diffs) * (1 + (length $ filter (==3) diffs))

diff xs = zipWith (-) (tail xs) xs

-- Part B

progB i = let jolts = 0:(sort $ map read $ lines i)
              jolts' = jolts ++ [last jolts + 3]
              diffs = diff jolts'
  in show $ product $ map ((drop 2 tribs) !!) $ map length $ filter ((== 1) . (!! 0)) $ group $ diffs

tribs = 0:0:1:zipWith (+) tribs (tail (zipWith (+) tribs $ tail tribs))

-- Equivalent to ((drop 2 trbs) !!) (but much slower). Was used to find the tribonacci sequence on the OEIS
-- myCount n = sum $ (\a b c -> if (a*3 + b*2 + c) == n then (fac (a+b+c)) `div` ((fac a) * (fac b) * (fac c)) else 0) <$> [0..n] <*> [0..n] <*> [0..n]
-- fac 0 = 1
-- fac n = n * fac (n - 1)
