module ShoppingCart.Api exposing (..)

import Dict exposing (fromList)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (object)
import Http exposing (Error)
import ShoppingCart.Types exposing (..)

-- HTTP


updateItem : ProductId -> Int -> Cmd Msg
updateItem id quantity =
    Http.send UpdateCart (Http.post "/cart/items" (Http.jsonBody (Encode.object [ ( "product_id", Encode.int id ), ( "quantity", Encode.int quantity ) ])) decodeCart)


fetchCart : Cmd Msg
fetchCart =
    Http.send UpdateCart (Http.get "/cart.json" decodeCart)


type alias JsonItem =
    { productId : Int, quantity : Int, productName : String, unitPrice : Float, subtotal : Float }


decodeCart : Decode.Decoder Cart
decodeCart =
    Decode.map buildCart (Decode.field "items" (Decode.list decodeItem))


buildCart : List JsonItem -> Cart
buildCart items =
    fromList
        (List.map
            (\i ->
                ( i.productId, { quantity = i.quantity, name = i.productName, unitPrice = i.unitPrice, subtotal = i.subtotal } )
            )
            items
        )


decodeItem : Decode.Decoder JsonItem
decodeItem =
    Decode.map5 JsonItem
        (Decode.field "productId" Decode.int)
        (Decode.field "quantity" Decode.int)
        (Decode.field "productName" Decode.string)
        (Decode.field "unitPrice" (Decode.map parseDecimal Decode.string))
        (Decode.field "subtotal" (Decode.map parseDecimal Decode.string))


parseDecimal : String -> Float
parseDecimal str =
    Result.withDefault 0 (String.toFloat str)
