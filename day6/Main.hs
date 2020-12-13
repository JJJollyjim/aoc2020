import           AOC
import           Data.List.Split (splitWhen)

count quantifier group = length $ filter (\q -> quantifier (elem q) group) ['a'..'z']

prog q = show . sum . map (count q) . splitWhen (== "") . lines

main = runAOC (prog any) (prog all)

