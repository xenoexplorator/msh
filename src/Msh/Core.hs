{-
 - Provides common types and functions to other components
 -}

module Msh.Core
   (
     Context(..), MshAction
   , initialContext, runMsh
     -- Re-exported functions related to the monad stack
   , asks, lift, throwError
   ) where

import Control.Monad.Except
import Control.Monad.Reader

-- msh execution context
data Context =
   Context { profileFile :: FilePath
           , prompt :: String
           }

initialContext :: Context
initialContext =
   Context "~/.profile"
           "$"

{-
 - Monadic representation of a shell action
 -}

type MshAction m = ExceptT String (ReaderT Context m)

runMsh :: Context -> MshAction m a -> m (Either String a)
runMsh = flip $ runReaderT . runExceptT
