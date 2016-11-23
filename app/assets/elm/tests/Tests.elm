module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import ShoppingCart exposing (..)
import Cart
import Api


all : Test
all =
    describe "Shopping Cart"
        [ Cart.all
        , Api.all
        ]
