module Main where

import Msh.Core
import Msh.Options

main :: IO ()
main = parseContext >>= runMsh shell >>= finalize

shell :: MshAction IO ()
shell = throwError "not implemented"

finalize :: Either String () -> IO ()
finalize (Left error) = putStrLn $ "Error: " ++ error
finalize _ = return ()
