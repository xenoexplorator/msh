module Msh.Core where

import Control.Monad.Except
import Control.Monad.State

-- msh execution context
data Context = Context { profileFile :: FilePath
                       }

-- msh monad stack
type MshAction = ExceptT String (StateT Context IO)

runMsh :: MshAction a -> Context -> IO (Either String a, Context)
runMsh = runStateT . runExceptT
