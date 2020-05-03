{-# LANGUAGE OverloadedStrings #-}

-- | Helpers for transforming integral value to and from alphanumeric, case-insensative text
module Data.Text.Base36
  ( encode
  , decode
  )
where

import           Data.Char             (chr, ord, toLower)
import           Data.Text             (Text)
import qualified Data.Text             as T

-- | Encode a value into base36 text
encode :: Integral a => a -> Text
encode 0 = "a"
encode i
    | i < 0     = encode (abs i) `T.append` encode 0
    | otherwise = T.pack $ map encodeMod $ takeWhile (/= (0, 0)) dms
  where
    dms = divMod i 36 : next dms
    next ((d, _) : dms') = divMod d 36 : next dms'

-- | Decode base36 text into a value
decode :: Integral a => Text -> a
decode "" = 0
decode str
    | T.last str == 'a' = negate $ decode $ T.init str
    | T.last str == 'A' = negate $ decode $ T.init str
    | otherwise         = foldr (\c i -> 36 * i + decodeMod c) 0 $ T.unpack str

encodeMod :: Integral a => (a, a) -> Char
encodeMod (_, m)
    |  0 <= m && m <= 25 = chr $ fromIntegral m + 97
    | 26 <= m && m <= 35 = chr $ fromIntegral m + 22
    | otherwise          = error "invalid modulus"

decodeMod :: Integral a => Char -> a
decodeMod c
    | 'a' <= c && c <= 'z' = fromIntegral $ ord c - 97
    | '0' <= c && c <= '9' = fromIntegral $ ord c - 22
    | 'A' <= c && c <= 'Z' = decodeMod $ toLower c
    | otherwise            = error "invalid character"
