module Lib
    ( translate
    ) where

import Token
import Network.HTTP.Simple
import Data.ByteString.UTF8
import qualified Data.ByteString.Lazy.UTF8 as L8
import qualified Data.ByteString.Char8 as B8

queryString :: String -> String -> String -> String -> [(B8.ByteString, Maybe B8.ByteString)]
queryString sl tl src tk = [ ("client", Just "t")
                           , ("sl", Just $ fromString sl)
                           , ("tl", Just $ fromString tk)
                           , ("hl", Just "en")
                           , ("dt", Just "at")
                           , ("dt", Just "bd")
                           , ("dt", Just "ex")
                           , ("dt", Just "ld")
                           , ("dt", Just "md")
                           , ("dt", Just "qca")
                           , ("dt", Just "rw")
                           , ("dt", Just "rm")
                           , ("dt", Just "ss")
                           , ("dt", Just "t")
                           , ("ie", Just "UTF-8")
                           , ("oe", Just "UTF-8")
                           , ("rom", Just "1")
                           , ("srcrom", Just "1")
                           , ("ssel", Just "3")
                           , ("tsel", Just "3")
                           , ("kc", Just "0")
                           , ("tk", Just $ fromString tk)
                           , ("q", Just $ fromString src)
                           ]
-- "client=t&sl=en&tl=ja&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=2&rom=1&ssel=0&tsel=0&kc=1&tk=335610.219646&q=sdfs"

translate :: String -> String -> String -> IO String
translate sl tl src = do
  token <- getToken src
  response <- httpLBS $ setRequestQueryString (queryString sl tl src token)
                      $ "https://translate.google.com/translate_a/single"
  return . show $ getResponseBody response
