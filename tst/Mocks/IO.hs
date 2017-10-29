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

runMock :: MshAction ((,) String) a -> (String, (Either String a, Settings))
runMock = runMsh (Context "") (Settings "")

execMock :: MshAction ((,) String) a -> String
execMock = fst . runMock

evalMock :: MshAction ((,) String) a -> (Either String a, Settings)
evalMock = snd . runMock
