import AOC (runAOC)

isTree = (== '#')

everyN n = map snd . filter ((== 0) . (`mod` n) . fst) . zip [0..]

countTrees dx dy = length . filter isTree . map (uncurry $ flip (!!)) . zip [0,dx..] . everyN dy . map cycle . lines

slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]

main = runAOC (show . countTrees 3 1) (show . product . ($ map (uncurry countTrees) slopes) . map . flip id)
