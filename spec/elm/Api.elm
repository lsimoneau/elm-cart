module Api exposing (all)

import Test exposing (..)
import Expect
import Dict
import ShoppingCart.Api exposing (..)
import ShoppingCart.Types exposing (..)
import Json.Decode exposing (..)


cartJson : String
cartJson =
    """
    {
      "id":55,
      "items": [
        {
          "productId": 1,
          "productName":"Sulfuras, hand of Ragnaros",
          "quantity":1,
          "unitPrice":"999.0",
          "subtotal":"999.0"
        }
      ],
      "total": "999.0"
    }
    """


expectedCart : Cart
expectedCart =
    { items = [ { productId = 1, name = "Sulfuras, hand of Ragnaros", quantity = 1, unitPrice = 999.0, subtotal = 999.0 } ], total = 999.0 }


all : Test
all =
    describe "JSON decoding"
        [ describe "Cart JSON decoder"
            [ test "decodes JSON" <|
                \() ->
                    cartJson
                        |> Json.Decode.decodeString cartDecoder
                        |> Expect.equal (Ok expectedCart)
            ]
        ]
