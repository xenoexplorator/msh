{-
 - Interpreter for the msh scripting language
 -}

module Msh.Lang
   ( runPrompt, echo
   ) where

import Msh.Core
import System.IO (hFlush, stdout)

runPrompt :: Context -> IO ()
runPrompt context =
   putStr (prompt context) >> putStr " " >> hFlush stdout

echo :: MshAction IO ()
echo = do
   cmd <- lift $ lift getLine
   lift . lift $ putStrLn cmd
