module Main where

import Msh.Core
import Msh.Lang
import Msh.Options

main :: IO ()
main = parseContext >>= shellLoop

shellLoop :: Context -> IO ()
shellLoop context = do
   runPrompt context
   result <- getLine >>= (runMsh context . runCommand)
   output result
   shellLoop context

output :: Either String () -> IO ()
output (Left err) = putStrLn err
output _ = pure ()
