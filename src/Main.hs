module Main where

import Msh.Core
import Msh.IO
import Msh.Lang
import Msh.Options
import System.IO (hFlush, stdout)

main :: IO ()
main = parseContext >>= shellLoop

shellLoop :: Context -> IO ()
shellLoop context = do
   (Right promptString) <- runMsh context getPrompt
   write promptString >> hFlush stdout
   result <- readLine >>= (runMsh context . runCommand)
   output result
   shellLoop context

output :: Either String () -> IO ()
output (Left err) = writeLn err
output _ = pure ()
