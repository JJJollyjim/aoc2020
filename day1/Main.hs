import           AOC (runAOC)

prog count = show . product . head . filter ((== 2020) . sum) . sequence . (replicate count) . (map read) . lines

main = runAOC (prog 2) (prog 3)
