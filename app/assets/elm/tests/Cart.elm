module Cart exposing (all)

import Test exposing (..)
import Expect
import String
import Dict
import ShoppingCart exposing (..)
import ShoppingCart.Cart exposing (..)
import ShoppingCart.Item exposing (..)

sulfuras : Item
sulfuras = { quantity = 1, unit_price = 99.0, subtotal = 99.0, name = "Sulfuras" }

brie : Item
brie = { quantity = 1, unit_price = 12.0, subtotal = 12.0, name = "Aged Brie" }

cart : Cart
cart = Dict.fromList [(123, sulfuras), (246, brie)]

all : Test
all =
    describe "Cart Model"
        [ test "incrementProduct" <|
            \() ->
              cart
              |> incrementProduct 246
              |> Expect.equal (Dict.fromList [(123, sulfuras), (246, { brie | quantity = 2})])
        ]
