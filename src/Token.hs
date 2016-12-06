module Token
    ( getToken
    ) where

import           Data.Bits
import           Network.HTTP.Simple
import           Text.Regex.Posix ((=~))
import           Text.Regex.Posix.ByteString.Lazy
import           Codec.Binary.UTF8.String as UTF8
import qualified Data.ByteString.Lazy.Char8 as L8

getToken :: String -> IO String
getToken src = do
  -- tkk <- updateTKK
  let tkk = (0,0)
  return $ generateTk tkk src

-- FIXME: cache TKK per hours
updateTKK :: IO (Integer, Integer)
updateTKK = do
  response <- httpLBS "https://translate.google.com/"
  return . parseTKK $ getResponseBody response

parseTKK :: L8.ByteString -> (Integer, Integer)
parseTKK body = (time, key)
  where pat = "TKK=[^ ]* a\\\\x3d([0-9]+);var b\\\\x3d(-?[0-9]+);return ([0-9]+)" :: L8.ByteString
        (_,_,_,(a:b:c:_)) = (body =~ pat) :: (L8.ByteString, L8.ByteString, L8.ByteString, [L8.ByteString])
        time = read $ L8.unpack c
        key = (read $ L8.unpack a) + (read $ L8.unpack b)

generateTk :: (Integer, Integer) -> String -> String
generateTk (time, key) src = do
  let utf8 = map toInteger $ encode src
  let r1 = foldl (\r c -> xr (r + c) "+-a^+6") time utf8
  let r2 = xor (xr r1 "+-3^+b+-f") key;
  let r3 = if r2 < 0 then (r2 .&. 2147483647) + 2147483648 else r2
  let r4 = mod r3 1000000
  (show r4) ++ "." ++ (show $ xor r4 time)

-- TODO: implement
xr :: Integer -> String -> Integer
xr a b = a
