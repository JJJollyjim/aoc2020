import AOC
import Data.Complex

main = runAOC prog progB

--- Part A

prog i = show $ round $ manhattan $ fst $ foldl (flip stepA) (0 :+ 0, 0) $ lines i

-- +1 is east, +i is north.
-- hdg is radians ccw from east.
stepA (char:numStr) (pos, hdg) = let num = read numStr
  in case char of
       'F' -> (pos + (real num * exp (0 :+ hdg)), hdg)
       'R' -> (pos, hdg - fromDeg num)
       'L' -> (pos, hdg + fromDeg num)
       'N' -> (pos + (0 :+ num), hdg)
       'S' -> (pos - (0 :+ num), hdg)
       'E' -> (pos + (num :+ 0), hdg)
       'W' -> (pos - (num :+ 0), hdg)

--- Part B

progB i = show $ round $ manhattan $ fst $ foldl (flip stepB) (0 :+ 0, 10 :+ 1) $ lines i

stepB (char:numStr) (pos, way) = let num = read numStr
  in case char of
       'F' -> (pos + real num * way, way)
       'L' -> (pos, way * (exp (0 :+ fromDeg num)))
       'R' -> (pos, way * (exp (0 :+ (-fromDeg num))))
       'N' -> (pos, way + (0 :+ num))
       'S' -> (pos, way - (0 :+ num))
       'E' -> (pos, way + (num :+ 0))
       'W' -> (pos, way - (num :+ 0))

--- Misc

real = (:+ 0)
tau = 2*pi
fromDeg n = tau * n / 360

manhattan (x :+ y) = abs x + abs y
