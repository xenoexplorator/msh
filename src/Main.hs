module Main where

import Msh.Core
import Msh.IO
import Msh.Lang
import Msh.Options
import System.Console.Haskeline hiding (Settings)

main :: IO ()
main = parseContext >>= runAction shell (Settings "$") >> return ()

shell :: Action IO ()
shell = do
   cmd <- input
   printResult $ runCommand cmd
   shell

input :: Action IO String
input = do
   result <- getPrompt >>= runInput . getInputLine
   maybe exitOK return result

runInput :: InputT IO a -> Action IO a
runInput = liftAction . runInputTWithPrefs prefs settings
   where prefs = defaultPrefs -- do not read .haskeline pref file
         settings = defaultSettings { historyFile = Just "./.msh_history" }

printResult :: Action IO () -> Action IO ()
printResult action = mkAction $ \settings context -> do
  (result, s') <- runAction action settings context
  either putStrLn (const $ pure ()) result
  return (Right (), s')
