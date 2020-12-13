{-# LANGUAGE TemplateHaskell #-}

import           AOC
import           Data.Complex
import           Control.Lens

data StateA = StateA { _pos :: Complex Double, _hdg :: Double }
makeLenses ''StateA

data StateB = StateB { _pos' :: Complex Double, _way :: Complex Double }
makeLenses ''StateB

main = runAOC prog progB

--- Part A

prog i = show $ round $ manhattan $ (^.pos) $ foldl (flip stepA) (StateA (0 :+ 0) 0) $ lines i

-- +1 is east, +i is north.
-- hdg is radians ccw from east.
stepA (char:numStr) = let num = read numStr
  in case char of
       'F' -> \s -> pos +~ (real num * exp (0 :+ s^.hdg)) $ s
       'R' -> hdg -~ fromDeg num
       'L' -> hdg +~ fromDeg num
       c   -> pos +~ unit c num

unit :: Char -> Double -> Complex Double
unit 'N' = (0 :+)
unit 'S' = (0 :+) . negate
unit 'E' = (:+ 0)
unit 'W' = (:+ 0) . negate

--- Part B

progB i = show $ round $ manhattan $ (^.pos') $ foldl (flip stepB) (StateB (0 :+ 0) (10 :+ 1)) $ lines i

stepB (char:numStr) = let num = read numStr
  in case char of
       'F' -> \s -> (pos' +~ real num * (s^.way)) s
       'L' -> way *~ exp (0 :+ fromDeg num)
       'R' -> way *~ exp (0 :+ (-fromDeg num))
       c   -> way +~ unit c num

--- Misc

real = (:+ 0)
tau = 2*pi
fromDeg n = tau * n / 360

manhattan (x :+ y) = abs x + abs y
