{-
 - Provides instances of the various msh monads for IO
 -}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Msh.IO
   ( ConsoleIO(..)
   , DirectoryIO(..)
   , SystemIO(..)
   ) where

import Msh.Core
import System.Directory (getCurrentDirectory, setCurrentDirectory)
import System.Exit (exitSuccess)

class Monad m => ConsoleIO m where
   readLine :: m String
   write :: String -> m ()
   writeLn :: String -> m ()

instance ConsoleIO IO where
   readLine = getLine
   write = putStr
   writeLn = putStrLn

instance ConsoleIO m => ConsoleIO (MshAction m) where
   readLine = lift . lift $ readLine
   write = lift . lift . write
   writeLn = lift . lift . writeLn

class Monad m => DirectoryIO m where
   getDirectory :: m FilePath
   setDirectory :: FilePath -> m ()

instance DirectoryIO IO where
   getDirectory = getCurrentDirectory
   setDirectory = setCurrentDirectory

instance DirectoryIO m => DirectoryIO (MshAction m) where
   getDirectory = lift . lift $ getDirectory
   setDirectory = lift . lift . setDirectory

class Monad m => SystemIO m where
   exitOK :: m a

instance SystemIO IO where
   exitOK = exitSuccess

instance SystemIO m => SystemIO (MshAction m) where
   exitOK = lift . lift $ exitOK
