module Tests exposing (..)

import Test exposing (..)
import Expect
import Api


all : Test
all =
    describe "Shopping Cart"
        [ Api.all
        ]
