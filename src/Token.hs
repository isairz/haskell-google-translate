module Token
    ( getToken
    ) where

import           Data.Bits
import           Data.Char
import           Network.HTTP.Simple
import           Text.Regex.Posix ((=~))
import           Text.Regex.Posix.ByteString.Lazy
import           Codec.Binary.UTF8.String as UTF8
import qualified Data.ByteString.Lazy.Char8 as L8

getToken :: String -> IO String
getToken src = do
  tkk <- updateTKK
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
  let r3 = mod r2 1000000
  (show r3) ++ "." ++ (show $ xor r3 time)

xr :: Integer -> [Char] -> Integer
xr r (a:b:c:rest) = xr r' rest
  where r1 = digitToInt c
        r2 = (if b == '+' then shiftR else shiftL) r r1
        r3 = (if a == '+' then (+) else xor) r r2
        r' = r3 .&. 0xffffffff
xr r _ = r
