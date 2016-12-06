module Main where

import Lib
import Text.Show.Unicode

toKorean :: String -> IO String
toKorean = translate "auto" "ko"

main :: IO ()
main = do
  result <- toKorean "最低です"
  uprint result
