import           AOC
import qualified Data.Vector as V

main = runAOC progA progB

-- Part A

progA = show . V.last . find (not . validate) . windows' . V.fromList . map read . lines

validate window = V.elem (V.last window) ((+) <$> V.init window <*> V.init window)

windows n vec = let length = V.length vec
                    starts = [0..(length-n)]
                in (\x -> V.slice x n vec) <$> starts

find f l = head $ filter f l

windows' vec = let length = V.length vec
  in windows (if length > 26 then 26 else 6) vec -- Test is different to the real thing

-- Part B

allSlidingWindowsInDecreasingOrderOfLength :: V.Vector a -> [V.Vector a]
allSlidingWindowsInDecreasingOrderOfLength vec = let length = V.length vec
                                                     lengths = [length,(length-1)..0]
                                                 in lengths >>= (`windows` vec)

progB i = let message = V.fromList $ map read $ lines i
              targ = V.last $ find (not . validate) $ windows' message
              thing = find ((== targ) . sum) $ allSlidingWindowsInDecreasingOrderOfLength message
        in show (minimum thing + maximum thing)
