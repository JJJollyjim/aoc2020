{-# LANGUAGE TemplateHaskell, NamedFieldPuns, TupleSections #-}
import           AOC
import           Control.Lens
import           Data.Bits
import           Data.Char          (digitToInt)
import           Data.Complex
import           Data.List          (foldl')
import qualified Data.Map as M
import           Data.Maybe         (catMaybes)
import           Text.Parsec        hiding (State)
import           Text.Parsec.String (Parser)


data MaskA = MaskA { _zero :: Int, _one :: Int } deriving (Show)
makeLenses ''MaskA

data Instruction = WriteMask String | WriteMem { _addr :: Int, _val :: Int } deriving (Show)
makeLenses ''Instruction
makePrisms ''Instruction

data State = State { _mask :: String, _mem :: M.Map Int Int } deriving (Show)
makeLenses ''State

main = runAOC progA progB

--- Part A

progA i = let Right p = parse program "" i
          in show $ sum $ (^.mem) (foldl' (flip execA) initState p)

execA :: Instruction -> State -> State
execA (WriteMask m) s = s & mask .~ m
execA WriteMem { _addr, _val } s = s & mem.at _addr ?~ applyMask (mkMaskA $ s^.mask) _val

mkMaskA = foldl' (flip f) (MaskA 0 0)
  where f 'X' = (zero *~ 2) . (one *~ 2)
        f '0' = (zero +~ 1) . (zero *~ 2) . (one *~ 2)
        f '1' = (one +~ 1) . (zero *~ 2) . (one *~ 2)

applyMask m i = i .&. complement (m^.zero) .|. (m^.one)

initState = State { _mask = undefined, _mem = M.empty }

--- Part B

progB i = let Right p = parse program "" i
          in show $ sum $ (^.mem) (foldl' (flip execB) initState p)

execB :: Instruction -> State -> State
execB (WriteMask m) s = s & mask .~ m
execB WriteMem { _addr, _val } s = s & (mem %~ M.union (M.fromList ((, _val) <$> addrs)))
  where addrs = sequence (allMaskFuncs (s^.mask)) _addr

allMaskFuncs mask = map (foldr1 (.)) $ sequence $ imap maskers $ reverse mask

maskers _ '0' = [id]
maskers bitn '1' = [flip setBit bitn]
maskers bitn 'X' = [flip setBit bitn, flip clearBit bitn]

--- Parsing

program :: Parser [Instruction]
program = sepEndBy instruction (char '\n')

instruction = try store <|> parseMask

store :: Parser Instruction
store = WriteMem <$> (string "mem[" *> num) <*> (string "] = " *> num)

parseMask :: Parser Instruction
parseMask = WriteMask  <$> (string "mask = " *> count 36 (oneOf "01X"))

num :: Parser Int
num = foldl' (\a i -> a * 10 + digitToInt i) 0 <$> many1 digit
