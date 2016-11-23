module Api exposing (all)

import Test exposing (..)
import Expect
import String
import Dict
import ShoppingCart exposing (..)
import ShoppingCart.Cart exposing (Cart)
import Json.Decode exposing (..)


expectedCart : Cart
expectedCart =ewiofjiowaejf;j;;;;;;
  Dict.fromList [(1, ({ name = "Sulfuras, hand of Ragnaros", quantity = 1, unitPrice = 999.0, subtotal = 999.0 }))]


cartJson : String
cartJson = """
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
  ]
}
"""

all : Test
all =
  describe "JSON decoding"
  [ describe "Cart JSON decoder"
      [ test "decodes JSON" <|
          \() ->
            cartJson
              |> Json.Decode.decodeString ShoppingCart.decodeCart
              |> Expect.equal (Ok expectedCart)
      ]
  ]
