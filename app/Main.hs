module Main where

import           Lib
import           Text.Show.Unicode

toKorean :: String -> IO String
toKorean = translate "auto" "ko"

main :: IO ()
main = do
  let src = "最低です"
  result <- toKorean src
  uprint $ "src: " ++ src
  uprint $ "result: " ++ result
