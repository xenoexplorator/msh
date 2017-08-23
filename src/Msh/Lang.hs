{-
 - Interpreter for the msh scripting language
 -}

module Msh.Lang
   ( runPrompt, runCommand, echo
   ) where

import Data.List (isPrefixOf)
import Msh.Core
import System.IO (hFlush, stdout)

runPrompt :: Context -> IO ()
runPrompt context =
   putStr (prompt context) >> putStr " " >> hFlush stdout

runCommand :: String -> MshAction IO ()
runCommand cmd
  | "echo " `isPrefixOf` cmd = lift . lift . putStrLn $ drop 5 cmd
  | otherwise = throwError $ "Unknown command : " ++ cmd

echo :: MshAction IO ()
echo = do
   cmd <- lift $ lift getLine
   lift . lift $ putStrLn cmd
