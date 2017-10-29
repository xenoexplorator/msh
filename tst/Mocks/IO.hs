{-# LANGUAGE FlexibleInstances #-}
module Mocks.IO where

import Msh.Core
import Msh.IO

data Mock = ReadLine | Write String
          | GetDir | SetDir String
          | Exit
          deriving (Eq, Show)

instance ConsoleIO ((,) [Mock]) where
   readLine = ([ReadLine], "")
   write s = ([Write s], ())
   writeLn s = write $ s ++ "\n"

instance DirectoryIO ((,) [Mock]) where
   getDirectory = ([GetDir], "testdir")
   setDirectory s = ([SetDir s], ())

instance SystemIO ((,) [Mock]) where
   exitOK = ([Exit], undefined)

runMock :: MshAction ((,) [Mock]) a -> ([Mock], (Either String a, Settings))
runMock = runMsh (Context "") (Settings "")

execMock :: MshAction ((,) [Mock]) a -> [Mock]
execMock = fst . runMock

evalMock :: MshAction ((,) [Mock]) a -> (Either String a, Settings)
evalMock = snd . runMock
