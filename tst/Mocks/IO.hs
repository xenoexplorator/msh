{-# LANGUAGE FlexibleInstances #-}
module Mocks.IO where

import Msh.Core
import Msh.IO

data Mock = ReadLine | Write String
          | GetDir | SetDir String
          | Exit | Exec String [String]
          deriving (Eq, Show)

instance ConsoleIO (Action ((,) [Mock])) where
   readLine = liftAction ([ReadLine], "")
   write s = liftAction ([Write s], ())
   writeLn s = write $ s ++ "\n"

instance DirectoryIO (Action ((,) [Mock])) where
   getDirectory = liftAction ([GetDir], "testdir")
   setDirectory s = liftAction ([SetDir s], ())

instance SystemIO (Action ((,) [Mock])) where
   exitOK = liftAction ([Exit], undefined)
   call prog args = liftAction ([Exec prog args], ())

runMock :: Action ((,) [Mock]) a -> ([Mock], (Either String a, Settings))
runMock action = runAction action (Settings "") (Context "")

execMock :: Action ((,) [Mock]) a -> [Mock]
execMock = fst . runMock

evalMock :: Action ((,) [Mock]) a -> (Either String a, Settings)
evalMock = snd . runMock
