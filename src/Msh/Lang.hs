{-
 - Interpreter for the msh scripting language
 -}

module Msh.Lang
   ( runPrompt, runCommand
   ) where

import Data.List (isPrefixOf)
import Msh.Core
import Msh.IO
import System.IO (hFlush, stdout)

runPrompt :: Context -> IO ()
runPrompt context =
   putStr (prompt context) >> putStr " " >> hFlush stdout

runCommand :: (ConsoleIO m, DirectoryIO m, SystemIO m) => String -> MshAction m ()
runCommand cmd
  | "exit" == cmd = exitOK
  | "pwd" == cmd = getDirectory >>= writeLn
  | "cd " `isPrefixOf` cmd = setDirectory $ drop 3 cmd
  | "echo " `isPrefixOf` cmd = writeLn $ drop 5 cmd
  | otherwise = throwError $ "Unknown command : " ++ cmd
