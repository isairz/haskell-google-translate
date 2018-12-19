# haksell-google-translate

A package that translate sentance by google for free

## Why

[Google Translate](https://translate.google.com) uses a token to authorize the requests. If you are not Google, you do not have this token and will have to [pay $20 per 1 million characters of text](https://cloud.google.com/translate/v2/pricing).

This package is the result of reverse engineering on the [obfuscated and minified code](https://translate.google.co.kr/translate/releases/twsfe_w_20161128_RC03/r/js/desktop_module_main.js) used by Google to generate such token.

## Example
```haskell
toKorean :: String -> IO String
toKorean = translate "auto" "ko"

main :: IO ()
main = do
  let src = "最低です"
  result <- toKorean src
  uprint $ "src: " ++ src
  uprint $ "result: " ++ result
```

## Reference
[@vitalets/google-translate-api](https://github.com/vitalets/google-translate-api)
