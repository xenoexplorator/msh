module Main where

import Msh.Core
import Msh.Lang
import Msh.Options

main :: IO ()
main = parseContext >>= shellLoop

shellLoop :: Context -> IO ()
shellLoop context = do
   runPrompt context
   runMsh echo context
   shellLoop context
