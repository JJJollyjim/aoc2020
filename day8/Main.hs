import AOC
-- import Text.Parsec
-- import Text.Parsec.String -- (Parser)

-- import Data.List (foldl')
-- import Data.Char (digitToInt)
import qualified Data.Set as Set
import Data.Vector ((!?), (//), Vector)
import qualified Data.Vector as V

type Program = Vector (String, Int)

main = runAOC progA progB

splitOnFirst c xs = (takeWhile (\x -> x /= c) xs, tail (dropWhile (\x -> x /= c) xs))

-- Part A

find f l = head $ filter f l

progA :: String -> String
progA i = let execution = runProg (parseProg i)
          in show $ snd $ find fst $ zip (findLoop (fst <$> execution)) (snd <$> execution)

findLoop :: Ord a => [a] -> [Bool]
findLoop pcs = zipWith (\pc set -> Set.member pc set) pcs histories
  where histories = scanl (\set pc -> Set.insert pc set) Set.empty pcs

runProg :: Program -> [(Int, Int)]
runProg = flip (iterateMaybe . runInst) (0, 0)

-- I must be able to build this out of monad behaviour?
iterateMaybe f x = case f x of
                     Just x -> x:(iterateMaybe f x)
                     Nothing -> []

runInst :: Program -> (Int, Int) -> Maybe (Int, Int)
runInst prog (pc, acc) = flip retire (pc, acc) <$> (prog !? pc)

retire ("nop", n) (pc, acc) = (pc+1, acc)
retire ("jmp", n) (pc, acc) = (pc+n, acc)
retire ("acc", n) (pc, acc) = (pc+1, acc+n)

parseProg :: String -> Program
parseProg = V.fromList . map (\l -> case (splitOnFirst ' ' l) of (op, arg) -> (op, parseInt arg)) . lines

parseInt :: String -> Int
parseInt ('+':num) = read num
parseInt num = read num

-- Part B

halts = (== []) . filter id . findLoop . map fst . runProg

mutants prog = map (\i -> prog // [(i, ("nop", 69))]) [0..(V.length prog - 1)]

accAtTerm = snd . last . runProg

progB = show . accAtTerm . find halts . mutants . parseProg
