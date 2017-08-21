{-
 - Provides common types and functions to other components
 -}

module Msh.Core
   (
     Context(..), MshAction
   , MshIO(..)
   , initialContext, runMsh
     -- Re-exported functions related to the monad stack
   , lift, throwError
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

-- msh IO monad wrapper
class MshIO m where
   getDirectory :: m String
   setDirectory :: String -> m ()

-- msh monad stack
type MshAction m = ExceptT String (ReaderT Context m)

runMsh :: MshAction m a -> Context -> m (Either String a)
runMsh = runReaderT . runExceptT
