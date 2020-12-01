import AOC (runAOC)

prog count x =
  let ns = (map read $ lines x) :: [Int]
      pairs = sequence (replicate count ns)
  in show $ product $ head $ filter ((== 2020) . sum) pairs

main = runAOC (prog 2) (prog 3)
