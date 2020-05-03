{-# LANGUAGE OverloadedStrings #-}

module Main
  ( main
  )
where

import           Data.Char                            (isAlphaNum)
import qualified Data.Text                            as T
import           Test.Framework
import           Test.Framework.Providers.HUnit
import           Test.Framework.Providers.QuickCheck2
import           Test.HUnit
import           Test.QuickCheck

import           Data.Text.Base36

main = defaultMain tests

tests = [ testProperty "Not null" prop_not_null
        , testProperty "Alphanumeric" prop_alpha_num
        , testProperty "Case insensitive" prop_case_insensitive
        , testProperty "Inverse" prop_inverse
        , testCase "Simple values" test_simple_values
        , testCase "Readme values" test_readme_values
        ]

prop_not_null = forAll base36 $ not . T.null

prop_alpha_num = forAll base36 $ all isAlphaNum . T.unpack

prop_case_insensitive = forAll base36 $ \a -> decode (T.toUpper a) == decode a

prop_inverse i = decode (encode i) == i
  where types = i :: Int

base36 = encode <$> (arbitrary :: Gen Int)

test_simple_values = map encode [0..35] @?= map T.singleton (['a'..'z']++['0'..'9'])

test_readme_values = encode 237816 @?= "asdf"
