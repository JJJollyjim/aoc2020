import           AOC           (runAOC)
import           Control.Monad (replicateM)

prog count = show . product . head . filter ((== 2020) . sum) . replicateM count . map read . lines

main = runAOC (prog 2) (prog 3)
