import AOC (runAOC)

splitOnFirst c xs = (takeWhile (\x -> x /= c) xs, tail (dropWhile (\x -> x /= c) xs))

parseLine :: String -> (Int, Int, Char, String)
parseLine line = let (start, rest) = splitOnFirst '-' line
                     (end, rest') = splitOnFirst ' ' rest
                     chr = head rest'
                     pass = (tail . tail . tail) rest'
                 in (read start, read end, chr, pass)

validateA (start, end, chr, pass) = count >= start && count <= end
  where count = length $ filter (== chr) pass

chrMatches chr pass idx = (pass !! (idx - 1)) == chr
validateB (idx1, idx2, chr, pass) = (chrMatches chr pass idx1) /= (chrMatches chr pass idx2)

prog pred = show . length . filter pred . map parseLine . lines

main = runAOC (prog validateA) (prog validateB)
