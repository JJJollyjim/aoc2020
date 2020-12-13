{-# LANGUAGE TupleSections #-}
import           AOC

import           Text.Parsec
import           Text.Parsec.String (Parser)

import           Data.Char          (digitToInt)
import           Data.List          (foldl')
import           Data.Maybe         (catMaybes)

main = runAOC progA progB

--- Part A
progA i = let Right (time, busses) = parse notes "" i
  in show $ head $ (\now -> ((now - time) *) <$> (arrivals (catMaybes busses) now)) =<< [time..]

arrivals busses time = filter ((== 0) . (time `mod`)) busses

--- Part B
progB i = let Right (_, busses) = parse notes "" i
  in show $ head $ foldl (\candidates pred -> fasterize $ filter pred candidates) [0..] (makePreds busses)

makePreds :: [Maybe Int] -> [Int -> Bool]
makePreds busses = map (\(i, n) -> (== 0) . (`mod` n) . (+ i)) $ catMaybes $ zipWith (\i n -> (i,) <$> n) [0..] busses

-- Takes a lazily-generated list, and returns the same list, but magically faster :D
--  * universiality not guaranteed
fasterize (x1:x2:_) = [x1,x2..]

--- Parsing

notes :: Parser (Int, [Maybe Int])
notes = (,) <$> (num <* char '\n') <*> busses

busses :: Parser [Maybe Int]
busses = sepBy bus (char ',')

bus :: Parser (Maybe Int)
bus = ((pure Nothing <$> string "x") <|> (Just <$> num))

num :: Parser Int
num = foldl' (\a i -> a * 10 + digitToInt i) 0 <$> many1 digit
