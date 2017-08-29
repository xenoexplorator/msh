{-# LANGUAGE FlexibleInstances #-}
import qualified Control.Monad.State as ST
import Msh.Core
import Msh.IO
import Msh.Lang
import Test.Framework
import Test.Framework.Providers.HUnit
import Test.HUnit

main :: IO ()
main = defaultMainWithOpts
   [ promptExpansionTests
   ] $ mempty { ropt_color_mode = Just ColorAlways }

promptExpansionTests = testGroup "Prompt expansion"
   [ testPromptExpand "expand current directory" "#pwd" "testdir "
   , testPromptExpand "bare prompt does not expand" "$" "$ "
   ]

testPromptExpand :: String -> String -> String -> Test.Framework.Test
testPromptExpand msg prompt expected = testCase msg $ assertEqual "" expected expanded
   where (Right expanded) = ST.evalState (runMsh (Context "" prompt) getPrompt) (Directory "testdir")

data Directory = Directory { current :: String }
instance DirectoryIO (ST.State Directory) where
   getDirectory = ST.gets current
   setDirectory = ST.put . Directory
