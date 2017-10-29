{-
 - Provides common types and functions to other components
 -}

module Msh.Core
   (
     Context(..), Settings(..), MshAction
   , initialContext, runMsh
     -- Re-exported functions related to the monad stack
   , asks, gets, lift, put, throwError
   ) where

import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.State

{-
 - Data structures representing the environment in which a shell action is evaluated
 - The Context type contains immutables defined when the shell is launched, while
 - the Settings type contains mutables that can be changed during an interactive session
 -}
data Context = Context
   { profileFile :: FilePath
   }

data Settings = Settings
   { prompt :: String
   }

initialContext :: Context
initialContext = Context "~/.profile"

{-
 - Monadic representation of a shell action
 -}

type MshAction m = ExceptT String (StateT Settings (ReaderT Context m))

runMsh :: Context -> Settings -> MshAction m a -> m (Either String a, Settings)
runMsh context settings = flip runReaderT context . flip runStateT settings . runExceptT
