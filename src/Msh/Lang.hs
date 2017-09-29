{-
 - Interpreter for the msh scripting language
 -}

module Msh.Lang
   ( getPrompt, runCommand
   ) where

import Data.List (isPrefixOf)
import Msh.Core
import Msh.IO

getPrompt :: DirectoryIO m => MshAction m String
getPrompt = asks prompt >>= expandPrompt

expandPrompt :: DirectoryIO m => String -> MshAction m String
expandPrompt pr
  | null pr = pure " " -- implicit space after prompt for readability
  | "#pwd" `isPrefixOf` pr = (++) <$> getDirectory <*> (expandPrompt $ drop 4 pr)
  | otherwise = let (p:ps) = pr in (p:) <$> expandPrompt ps

runCommand :: (ConsoleIO m, DirectoryIO m, SystemIO m) => String -> MshAction m ()
runCommand cmd
  | null cmd = pure ()
  | "exit" == cmd = exitOK
  | "pwd" == cmd = getDirectory >>= writeLn
  | "cd " `isPrefixOf` cmd = setDirectory $ drop 3 cmd
  | "echo " `isPrefixOf` cmd = writeLn $ drop 5 cmd
  | otherwise = throwError $ "Unknown command : " ++ cmd
