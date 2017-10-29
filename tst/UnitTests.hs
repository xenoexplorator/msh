import Mocks.IO
import Msh.Core
import Msh.IO
import Msh.Lang
import Test.Framework
import Test.Framework.Providers.HUnit
import Test.HUnit

main :: IO ()
main = defaultMainWithOpts
   [ promptExpansionTests
   , builtinCommandsTests
   ] $ mempty { ropt_color_mode = Just ColorAlways }

promptExpansionTests = testGroup "Prompt expansion"
   [ testCase "expand current directory" $ Right "testdir " @=? evalPrompt "#pwd"
   , testCase "bare prompt does not expand" $ Right "$ " @=? evalPrompt "$"
   , testCase "expansion occurs inside the prompt string" $ Right "(testdir) " @=? evalPrompt "(#pwd)"
   ]

evalPrompt :: String -> Either String String
evalPrompt p = (fst . snd :: (String, (a,b)) -> a) $ runMsh (Context "") (Settings p) getPrompt

builtinCommandsTests = testGroup "Built-in commands"
   [ testCase "execute exit command" $ "exitOK" @=? execMock (runCommand "exit")
   , testCase "execute pwd command" $ "testdir\n" @=? execMock (runCommand "pwd")
   , testCase "execute cd command" $ "test" @=? execMock (runCommand "cd test")
   , testCase "execute echo command" $ "test\n" @=? execMock (runCommand "echo test")
   , testCase "execute prompt= command" $ "test" @=? evalMockSettings (runCommand "prompt=test")
   ]

evalMockSettings = extract . evalMock
   where extract (_, Settings s) = s
