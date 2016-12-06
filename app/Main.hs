module Main where

import Lib

toKorean :: String -> IO String
toKorean = translate "auto" "ko"

main :: IO ()
main = do
  result <- toKorean "最低です"
  print result
