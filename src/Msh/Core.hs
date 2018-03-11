{-
 - Provides common types and functions to other components
 -}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Msh.Core
   (
     Context(..), Settings(..), Action(..)
   , initialContext, runAction, mkAction
     -- Re-exported functions related to the monad stack
   , asks, gets, lift, put
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

newtype Action m a = Action (ExceptT String (StateT Settings (ReaderT Context m)) a)
   deriving (Functor, Applicative, Monad, MonadState Settings)

runAction :: Action m a -> Settings -> Context -> m (Either String a, Settings)
runAction (Action act) = (runReaderT .) $ runStateT . runExceptT $ act

mkAction :: (Settings -> Context -> m (Either String a, Settings)) -> Action m a
mkAction = Action . ExceptT . StateT . (ReaderT .)
