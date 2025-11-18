module Main where

import Exercises
import Test.HUnit

main :: IO ()
main = do
  let t1 = TestCase (assertEqual "firstThenApply"
            (Just 6) (firstThenApply [1..10] even (*3)))
      t2 = TestCase (assertEqual "powers take 5"
            [1,3,9,27,81] (take 5 (powers 3)))
      t3 = TestCase (assertEqual "inorder"
            [1,2,3,4,5] (inorder (foldr insert empty [3,1,4,1,5])))
  _ <- runTestTT (TestList [t1,t2,t3])
  pure ()
