{-
 - Provides instances of the various msh monads for IO
 -}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Msh.IO () where

import Msh.Core
import System.Directory (getCurrentDirectory, setCurrentDirectory)

instance ConsoleIO IO where
   readLine = getLine
   write = putStr
   writeLn = putStrLn

instance DirectoryIO IO where
   getDirectory = getCurrentDirectory
   setDirectory = setCurrentDirectory
