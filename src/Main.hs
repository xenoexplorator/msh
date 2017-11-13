module Main where

import Msh.Core
import Msh.IO
import Msh.Lang
import Msh.Options
import System.Console.Haskeline hiding (Settings)

main :: IO ()
main = parseContext >>= shellLoop (Settings "$")

shellLoop :: Settings -> Context -> IO ()
shellLoop settings context = runMsh context settings repl >>= output . fst

output :: Either String () -> IO ()
output (Left err) = writeLn err
output _ = pure ()

repl :: MshAction IO ()
repl = readInput >>= runCommand >> repl

readInput :: MshAction IO String
readInput = do
   promptString <- getPrompt
   (Just result) <- runMshInput $ getInputLine promptString
   pure result
   where runMshInput = lift . lift . lift . runInputTWithPrefs mshPrefs mshSettings
         mshPrefs = defaultPrefs -- do not read .haskeline pref file
         mshSettings = defaultSettings { historyFile = Just "./.msh_history" }

