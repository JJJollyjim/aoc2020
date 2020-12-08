import AOC
import Text.Parsec
import Text.Parsec.String -- (Parser)

import Data.List (foldl')
import Data.Char (digitToInt)
import qualified Data.Set as Set
import Data.Set (Set, union)

main = runAOC progA progB

findFixed f x = let x' = f x in if x == x' then x else findFixed f x'

target = "shiny gold"

-- Part A

progA :: String -> String
progA input = let Right defsFull = parse parser "" input
                  defs = (\(a,b) -> (a,fst <$> b)) <$> defsFull
              in show $ length $ Set.delete target $ findFixed (findParents defs) (Set.singleton target)

findParents defs s = s `Set.union` (Set.fromList $ map fst $ filter (\(p, xs) -> any (flip elem s) xs) defs)

-- Part B

progB :: String -> String
progB input = let Right defs = parse parser "" input
              in show $ countChildren defs target

countChildren defs s = case lookup s defs of (Just children) -> sum $ (\(c, n) -> n * (1 + (countChildren defs c))) <$> children

-- Parsing

parser = many line

word = many letter

colour = word <> string " " <> word
bag = colour <* space <* string "bag" <* optionMaybe (char 's')

numBag = flip (,) <$> (num <* space) <*> bag
contents = (string "no other bags" *> pure []) <|> (numBag `sepBy` (string ", "))

line = (,) <$> (bag <* space <* string "contain" <* space) <*> (contents <* (string "." <* newline))

num :: Parser Int
num = (foldl' (\a i -> a * 10 + digitToInt i) 0 <$> many1 digit) <|> (string "no" *> pure 0)
