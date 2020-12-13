{-# LANGUAGE BangPatterns #-}
import           AOC

import           Data.Maybe  (catMaybes, fromMaybe)
import qualified Data.Vector as V

main = runAOC progA progB

-- Part A

progA = prog (mkDecider 4) castOneStep

castOneStep !floor !c !dc = getAt floor $ add c dc

-- Part B

progB = prog (mkDecider 5) castB

castB !floor !c !dc = let c' = add dc c
  in case getAt floor c' of
       Nothing  -> Nothing
       Just '.' -> castB floor c' dc
       Just !s  -> Just s

-- Shared

prog !decider !caster i = let floor = V.fromList $ map V.fromList $ lines i
          in show $ V.sum $ V.map countOccV $ findFixed (step decider caster) floor

step !decider !caster !floor = V.imap (\y row -> V.imap (\x this -> decider this (countOcc (catMaybes $ caster floor (x,y) <$> neighbourDeltas))) row) floor

neighbourDeltas = filter (/= (0,0)) $ (,) <$> [-1..1] <*> [-1..1]

getAt !floor (x,y) = floor V.!? y >>= (V.!? x)

allCoords !floor = (,) <$> [0..(V.length $ V.head floor)] <*> [0..(V.length floor)]

countOcc = length . filter (== '#')
countOccV = V.length . V.filter (== '#')

mkDecider !min = f where
  f 'L' 0 = '#'
  f '#' !n | n >= min = 'L'
  f !x  !_ = x

findFixed !f !x = let x' = f x in if x == x' then x else findFixed f x'

add (!a,!b) (!c,!d) = (a+c, b+d)
