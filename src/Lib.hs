module Lib
    ( translate
    ) where

import Token
import Network.HTTP.Simple
import qualified Data.ByteString.Lazy.Char8 as L8

translate :: String -> IO (String)
translate src = do
  token <- getToken
  return token

