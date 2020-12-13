import AOC

import Text.Parsec
import Text.Parsec.String (Parser)

import Data.List (foldl')
import Data.Maybe (catMaybes)
import Data.Char (digitToInt)

main = runAOC progA progB

--- Part A
progA i = let Right (time, busses) = parse notes "" i
          in show $ head $ (\now -> ((now - time) *) <$> (arrivals (catMaybes busses) now)) =<< [time..]

arrivals busses time = filter ((== 0) . (time `mod`)) busses

--- Part B
progB = undefined

--- Parsing

notes :: Parser (Int, [Maybe Int])
notes = (,) <$> (num <* char '\n') <*> busses

busses :: Parser [Maybe Int]
busses = sepBy bus (char ',')

bus :: Parser (Maybe Int)
bus = ((pure Nothing <$> string "x") <|> (Just <$> num))

num :: Parser Int
num = foldl' (\a i -> a * 10 + digitToInt i) 0 <$> many1 digit
