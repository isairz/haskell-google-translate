module Token
    ( getToken
    ) where
import           Network.HTTP.Simple
import           Text.Regex.Posix ((=~))
import           Text.Regex.Posix.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8 as L8

getToken :: IO String
getToken = do
  tkk <- updateTKK
  return $ show $ tkk

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

