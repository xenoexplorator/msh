{-
 - Provides instances of the various msh monads for IO
 -}
{-# LANGUAGE FlexibleInstances #-} -- to declare newtype instances

module Msh.IO
   ( ConsoleIO(..)
   , DirectoryIO(..)
   , SystemIO(..)
   , liftAction
   ) where

import Control.Exception
import Control.Monad.Trans
import Msh.Core
import System.Directory (getCurrentDirectory, setCurrentDirectory)
import System.Exit (exitSuccess)
import System.Process (callProcess)

liftAction :: Monad m => m a -> Action m a
liftAction = Action . lift . lift . lift

class Monad m => ConsoleIO m where
   readLine :: m String
   write :: String -> m ()
   writeLn :: String -> m ()

instance ConsoleIO (Action IO) where
   readLine = liftAction getLine
   write = liftAction . putStr
   writeLn = liftAction . putStrLn

class Monad m => DirectoryIO m where
   getDirectory :: m FilePath
   setDirectory :: FilePath -> m ()

instance DirectoryIO (Action IO) where
   getDirectory = liftAction getCurrentDirectory
   setDirectory = liftAction . setCurrentDirectory

class Monad m => SystemIO m where
   exitOK :: m a
   call :: FilePath -> [String] -> m ()

instance SystemIO (Action IO) where
   exitOK = Action . lift . lift . lift $ exitSuccess
   call prg args = mkAction $ \set _ -> do
      let handler :: IOError -> IO (Either String a)
          handler _ = return . Left $ prg ++ " <> command not found"
      result <- catch (Right <$> callProcess prg args) handler
      return (result, set)
