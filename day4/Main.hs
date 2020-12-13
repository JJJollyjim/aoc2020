import           AOC             (runAOC)

import           Data.List       (partition)
import           Data.List.Split (splitWhen)
import           Text.Read       (readMaybe)

splitOnFirst c xs = (takeWhile (\x -> x /= c) xs, tail (dropWhile (\x -> x /= c) xs))

isJust (Just _) = True
isJust Nothing  = False

hasKey :: (Eq k) => k -> [(k, a)] -> Bool
hasKey k l = isJust $ lookup k l

isValid preds p = (==0) $ length $ filter not $ preds <*> [p]

validatorsA = [ hasKey "byr"
              , hasKey "iyr"
              , hasKey "eyr"
              , hasKey "hgt"
              , hasKey "hcl"
              , hasKey "ecl"
              , hasKey "pid"
              ]

atleast min n | n >= min = return n
              | otherwise = fail ""

atmost max n | n <= max = return n
             | otherwise = fail ""

inrange min max = (atleast min =<<) . (atmost max)

checkheight (n, "cm") = readMaybe n >>= inrange 150 193
checkheight (n, "in") = readMaybe n >>= inrange 59 76
checkheight _         = Nothing

hexes = ['0'..'9'] ++ ['a'..'f']
digits = ['0'..'9']

splitHeight :: String -> (String, String)
splitHeight xs = (takeWhile (flip elem digits) xs, dropWhile (flip elem digits) xs)

inlist xs x = if elem x xs then return x else fail ""

checkhair ['#',a,b,c,d,e,f] = mapM (inlist hexes) [a,b,c,d,e,f]
checkhair _                 = Nothing

checkeye = inlist ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

checkpid [a,b,c,d,e,f,g,h,i] = mapM (inlist digits) [a,b,c,d,e,f,g,h,i]
checkpid _                   = Nothing

validatorsB = [ isJust . (inrange 1920 2002 =<<) . (readMaybe =<<) . lookup "byr"
              , isJust . (inrange 2010 2020 =<<) . (readMaybe =<<) . lookup "iyr"
              , isJust . (inrange 2020 2030 =<<) . (readMaybe =<<) . lookup "eyr"
              , isJust . (checkheight . splitHeight =<<) . lookup "hgt"
              , isJust . (checkhair =<<) . lookup "hcl"
              , isJust . (checkeye =<<) . lookup "ecl"
              , isJust . (checkpid =<<) . lookup "pid"
              ]

prog preds f = show $ length $ filter (isValid preds) passports
  where passports = map (map (splitOnFirst ':')) $ splitWhen (\x -> x == "") $ splitWhen (\x -> (x == ' ') || (x == '\n')) f

main = runAOC (prog validatorsA) (prog validatorsB)
