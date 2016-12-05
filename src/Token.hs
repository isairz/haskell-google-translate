module Token
    ( getToken
    ) where
import           Network.HTTP.Simple
import qualified Data.ByteString.Lazy.Char8 as L8

updateTKK :: IO (L8.ByteString)
updateTKK = do
  let request = "https://translate.google.com/"
  response <- httpLBS request
  return $ getResponseBody response

getToken :: IO (String)
getToken = do
    tkk <- updateTKK
    return $ show $ tkk
