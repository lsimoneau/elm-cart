module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import ShoppingCart exposing (..)
import Cart


all : Test
all =
    describe "Shopping Cart"
        [ Cart.all ]
