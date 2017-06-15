module Msh.Core
   ( -- Core application types and related functions
     Context(..), MshAction
   , initialContext, runMsh
     -- Re-exported functions related to the monad stack
   , throwError
   ) where

import Control.Monad.Except
import Control.Monad.State

-- msh execution context
data Context =
   Context { profileFile :: FilePath
           }

initialContext :: Context
initialContext =
   Context "~/.profile"

-- msh monad stack
type MshAction = ExceptT String (StateT Context IO)

runMsh :: MshAction a -> Context -> IO (Either String a, Context)
runMsh = runStateT . runExceptT
