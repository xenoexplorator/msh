{-# LANGUAGE FlexibleInstances #-}
module Mocks.IO where

import Msh.Core
import Msh.IO

instance ConsoleIO ((,) String) where
   readLine = ("", "testinput")
   write = flip (,) ()
   writeLn = flip (,) () . (++ "\n")

instance DirectoryIO ((,) String) where
   getDirectory = ("", "testdir")
   setDirectory = flip (,) ()

instance SystemIO ((,) String) where
   exitOK = ("exitOK", undefined)

execMock :: MshAction ((,) String) a -> String
execMock = fst . (runMsh (Context "") (Settings ""))
