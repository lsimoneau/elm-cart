module ShoppingCart.Http exposing (fetchCart)

import Json.Decode exposing (..)
import Http exposing (Error)


fetchCart : Cmd Msg
fetchCart =
  Http.send LoadCart (Http.get "/cart.json" decodeCart)


type alias JsonItem =
  { productId: Int, quantity: Int, productName: String, unitPrice: Float, subtotal: Float }


decodeCart : Decoder Cart
decodeCart =
  map buildCart (field "items" (list decodeItem))


buildCart : List JsonItem -> Cart
buildCart items =
  Dict.fromList (List.map (\i ->
    (i.productId, { quantity = i.quantity, name = i.productName, unitPrice = i.unitPrice, subtotal = i.subtotal })
  ) items)


decodeItem : Decoder JsonItem
decodeItem =
  map5 JsonItem
    (field "productId" int)
    (field "quantity" int)
    (field "productName" string)
    (field "unitPrice" (map parseDecimal string))
    (field "subtotal" (map parseDecimal string))


parseDecimal : String -> Float
parseDecimal str =
  Result.withDefault 0 (String.toFloat str)
