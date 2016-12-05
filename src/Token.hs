module Token
    ( getToken
    ) where
import           Network.HTTP.Simple
import           Text.Regex.Posix
import           Text.Regex.Posix.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8 as L8

-- FIXME: cache TKK per hours
updateTKK :: IO (Integer, Integer)
updateTKK = do
  response <- httpLBS "https://translate.google.com/"
  let body = getResponseBody response
  let pat = "TKK=[^ ]* a\\\\x3d([0-9]+);var b\\\\x3d(-?[0-9]+);return ([0-9]+)" :: L8.ByteString
  let (_,_,_,d) = (body =~ pat) :: (L8.ByteString, L8.ByteString, L8.ByteString, [L8.ByteString])
  let a:b:c:_ = d
  let time = read $ L8.unpack c
  let key = (read $ L8.unpack a) + (read $ L8.unpack b)
  return (time, key)

getToken :: IO String
getToken = do
    tkk <- updateTKK
    return $ show $ tkk
