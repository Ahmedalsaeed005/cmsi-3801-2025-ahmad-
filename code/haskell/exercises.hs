module Exercises
  ( firstThenApply
  , powers
  , countValidLines
  , Shape(..), area, volume
  , Tree(Empty), empty, insert, member, count, inorder, treeString
  ) where

import Data.Char (isSpace)
import Data.List (find)

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = f <$> find p xs

powers :: Integral a => a -> [a]
powers b = iterate (* b) 1

countValidLines :: FilePath -> IO Int
countValidLines path = do
  contents <- readFile path
  let good l =
        case dropWhile isSpace l of
          ""      -> False
          ('#':_) -> False
          _       -> True
  pure . length . filter good . lines $ contents

data Shape
  = Box    { w :: Double, h :: Double, d :: Double }
  | Sphere { r :: Double }
  deriving (Eq)

area :: Shape -> Double
area (Box w h d) = 2 * (w*h + w*d + h*d)
area (Sphere r)  = 4 * pi * r * r

volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r)  = (4 / 3) * pi * r * r * r

instance Show Shape where
  show (Box w h d) = "Box(" ++ show w ++ "," ++ show h ++ "," ++ show d ++ ")"
  show (Sphere r)  = "Sphere(" ++ show r ++ ")"

data Tree a
  = Empty
  | Node (Tree a) a (Tree a)
  deriving (Eq)

empty :: Tree a
empty = Empty

insert :: Ord a => a -> Tree a -> Tree a
insert x Empty = Node Empty x Empty
insert x (Node l v r)
  | x < v     = Node (insert x l) v r
  | x > v     = Node l v (insert x r)
  | otherwise = Node l v r

member :: Ord a => a -> Tree a -> Bool
member _ Empty = False
member x (Node l v r)
  | x < v     = member x l
  | x > v     = member x r
  | otherwise = True

count :: Tree a -> Int
count Empty        = 0
count (Node l _ r) = 1 + count l + count r

inorder :: Tree a -> [a]
inorder Empty        = []
inorder (Node l v r) = inorder l ++ [v] ++ inorder r

treeString :: Show a => Tree a -> String
treeString Empty        = "∅"
treeString (Node l v r) =
  "(" ++ treeString l ++ " <- " ++ show v ++ " -> " ++ treeString r ++ ")"
