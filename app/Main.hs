module Main where

import Lib

main :: IO ()
main = do
  result <- translate "最低です"
  print result
