import           AOC
import           Numeric (readInt)

readBinary c0 c1 = readInt 2 valid conv
  where valid c = c == c0 || c == c1
        conv c | c == c0 = 0
               | c == c1 = 1

readRow = readBinary 'F' 'B'
readCol = readBinary 'L' 'R'

readSeat str = let [(row, rest)] = readRow str
                   [(col, "")] = readCol rest
               in (row, col)

seatId (row, col) = row*8 + col

allIds = map (seatId . readSeat) . lines

onlyElem [x] = x

mySeat ids = onlyElem $ filter (not . flip elem ids) [minimum ids..maximum ids]

partA = show . maximum . allIds
partB = show . mySeat . allIds

main = runAOC partA partB
