{-
 - Interpreter for the msh scripting language
 -}

module Msh.Lang
   ( runPrompt, runCommand, echo
   ) where

import Data.List (isPrefixOf)
import Msh.Core
import Msh.IO ()
import System.Exit (exitSuccess)
import System.IO (hFlush, stdout)

runPrompt :: Context -> IO ()
runPrompt context =
   putStr (prompt context) >> putStr " " >> hFlush stdout

runCommand :: String -> MshAction IO ()
runCommand cmd
  | "exit" == cmd = lift . lift $ exitSuccess
  | "pwd" == cmd = getDirectory >>= writeLn
  | "cd " `isPrefixOf` cmd = setDirectory $ drop 3 cmd
  | "echo " `isPrefixOf` cmd = writeLn $ drop 5 cmd
  | otherwise = throwError $ "Unknown command : " ++ cmd

echo :: MshAction IO ()
echo = do
   cmd <- lift $ lift getLine
   lift . lift $ putStrLn cmd
