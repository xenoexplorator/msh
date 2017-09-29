module Main where

import Msh.Core
import Msh.IO
import Msh.Lang
import Msh.Options
import System.Console.Haskeline

main :: IO ()
main = parseContext >>= shellLoop

shellLoop :: Context -> IO ()
shellLoop context = do
   (runMsh context $ readInput >>= runCommand) >>= output
   shellLoop context

output :: Either String () -> IO ()
output (Left err) = writeLn err
output _ = pure ()

readInput :: MshAction IO String
readInput = do
   promptString <- getPrompt
   (Just result) <- runMshInput $ getInputLine promptString
   pure result
   where runMshInput = lift . lift . runInputTWithPrefs mshPrefs mshSettings
         mshPrefs = defaultPrefs -- do not read .haskeline pref file
         mshSettings = defaultSettings { historyFile = Just "./.msh_history" }
