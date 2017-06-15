module Main where

import Msh.Core
import Msh.Options

main :: IO ()
main = parseContext >>= runMsh shell >>= uncurry finalize

shell :: MshAction ()
shell = throwError "not implemented"

finalize :: Either String () -> Context -> IO ()
finalize (Left error) _ = putStrLn $ "Error: " ++ error
finalize _ _ = return ()
