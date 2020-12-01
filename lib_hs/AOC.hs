module AOC (runAOC)
  where
import System.Environment (getArgs)

runAOC :: (String -> String) -> (String -> String) -> (IO ())
runAOC a b = getArgs >>= (interact . part . head)
  where part "a" = a
        part "b" = b
