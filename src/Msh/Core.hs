{-
 - Provides common types and functions to other components
 -}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Msh.Core
   (
     Context(..), MshAction
   , initialContext, runMsh
   , ConsoleIO(..), DirectoryIO(..)
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

{-
 - msh common monads
 - MshAction represents an action executed by the shell or script interpreter
 - Other monads encapsulates specific IO behaviors to describe specific actions more finely
 - and allow for automated tests of IO actions
 -}

type MshAction m = ExceptT String (ReaderT Context m)

runMsh :: Context -> MshAction m a -> m (Either String a)
runMsh = flip $ runReaderT . runExceptT

class ConsoleIO m where
   readLine :: m String
   write :: String -> m ()
   writeLn :: String -> m ()

instance (ConsoleIO m, Monad m) => ConsoleIO (MshAction m) where
   readLine = lift . lift $ readLine
   write = lift . lift . write
   writeLn = lift . lift . writeLn

class DirectoryIO m where
   getDirectory :: m FilePath
   setDirectory :: FilePath -> m ()

instance (DirectoryIO m, Monad m) => DirectoryIO (MshAction m) where
   getDirectory = lift . lift $ getDirectory
   setDirectory = lift . lift . setDirectory
