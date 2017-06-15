module Msh.Core
   ( -- Core application types and related functions
     Context(..), MshAction
   , initialContext, runMsh
     -- Re-exported functions related to the monad stack
   , throwError
   ) where

import Control.Monad.Except
import Control.Monad.Reader

-- msh execution context
data Context =
   Context { profileFile :: FilePath
           }

initialContext :: Context
initialContext =
   Context "~/.profile"

-- msh monad stack
type MshAction m = ExceptT String (ReaderT Context m)

runMsh :: MshAction m a -> Context -> m (Either String a)
runMsh = runReaderT . runExceptT
