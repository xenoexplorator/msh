module Main where

import Msh.Core
import Msh.IO
import Msh.Lang
import Msh.Options
import System.Console.Haskeline hiding (Settings)

main :: IO ()
main = parseContext >>= flip shellLoop (Settings "$")

shellLoop :: Context -> Settings -> IO ()
shellLoop context settings = do
   (result, settings') <- runMsh context settings $ readInput >>= runCommand
   output result
   shellLoop context settings'

output :: Either String () -> IO ()
output (Left err) = writeLn err
output _ = pure ()

readInput :: MshAction IO String
readInput = do
   promptString <- getPrompt
   (Just result) <- runMshInput $ getInputLine promptString
   pure result
   where runMshInput = lift . lift . lift . runInputTWithPrefs mshPrefs mshSettings
         mshPrefs = defaultPrefs -- do not read .haskeline pref file
         mshSettings = defaultSettings { historyFile = Just "./.msh_history" }
