{-
 - Defines and handle program arguments for the shell
 -}

module Msh.Options
   ( parseContext
   ) where

import Data.Semigroup((<>))
import Msh.Core
import Options.Applicative

context :: Parser Context
context = Context
   <$> strOption
      ( long "profile"
      <> short 'P'
      <> value "~/.profile"
      <> help "Location of the profile to be loaded")
   <*> strOption
      ( long "prompt"
      <> short 'p'
      <> value "$"
      <> help "Main prompt string")

parseContext :: IO Context
parseContext = execParser $ info (helper <*> context)
   ( fullDesc
   <> progDesc "msh, a monadic shell")
