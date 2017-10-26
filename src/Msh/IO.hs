{-
 - Provides instances of the various msh monads for IO
 -}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE UndecidableInstances #-}

module Msh.IO
   ( ConsoleIO(..)
   , DirectoryIO(..)
   , SystemIO(..)
   ) where

import Control.Monad.Trans
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

instance (ConsoleIO m, MonadTrans t, Monad (t m)) => ConsoleIO (t m) where
   readLine = lift readLine
   write = lift . write
   writeLn = lift . writeLn

class Monad m => DirectoryIO m where
   getDirectory :: m FilePath
   setDirectory :: FilePath -> m ()

instance DirectoryIO IO where
   getDirectory = getCurrentDirectory
   setDirectory = setCurrentDirectory

instance (DirectoryIO m, MonadTrans t, Monad (t m)) => DirectoryIO (t m) where
   getDirectory = lift getDirectory
   setDirectory = lift . setDirectory

class Monad m => SystemIO m where
   exitOK :: m a

instance SystemIO IO where
   exitOK = exitSuccess

instance (SystemIO m, MonadTrans t, Monad (t m)) => SystemIO (t m) where
   exitOK = lift exitOK
