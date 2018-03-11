{-
 - Interpreter for the msh scripting language
 -}
{-# LANGUAGE FlexibleContexts #-} -- used for Class (Action m) constraints

module Msh.Lang
   ( getPrompt, runCommand
   ) where

import Data.List (isPrefixOf)
import Msh.Core
import Msh.IO

getPrompt :: (Monad m, DirectoryIO (Action m)) => Action m String
getPrompt = gets prompt >>= expandPrompt

expandPrompt :: DirectoryIO (Action m) => String -> Action m String
expandPrompt pr
  | null pr = pure " " -- implicit space after prompt for readability
  | "#pwd" `isPrefixOf` pr = (++) <$> getDirectory <*> (expandPrompt $ drop 4 pr)
  | otherwise = let (p:ps) = pr in (p:) <$> expandPrompt ps

runCommand :: (Monad m, ConsoleIO (Action m), DirectoryIO (Action m), SystemIO (Action m)) =>
   String -> Action m ()
runCommand cmd
  | null cmd = pure ()
  | "exit" == cmd = exitOK
  | "pwd" == cmd = getDirectory >>= writeLn
  | "cd " `isPrefixOf` cmd = setDirectory $ drop 3 cmd
  | "echo " `isPrefixOf` cmd = writeLn $ drop 5 cmd
  | "prompt=" `isPrefixOf` cmd = put . Settings $ drop 7 cmd
  | otherwise = let (prog:args) = words cmd in call prog args
