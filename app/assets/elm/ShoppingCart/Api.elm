module ShoppingCart.Api exposing (..)

import Dict exposing (fromList)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (object)
import Http exposing (Error)
import ShoppingCart.Types exposing (..)


-- HTTP


type alias JsonItem =
    { productId : Int, quantity : Int, productName : String, unitPrice : Float, subtotal : Float }


updateItem : ProductId -> Int -> Cmd Msg
updateItem id quantity =
    Http.send UpdateCart (updateItemRequest id quantity)


updateItemRequest : ProductId -> Int -> Http.Request Cart
updateItemRequest id quantity =
    Http.post "/cart/items" (updateItemBody id quantity) cartDecoder


updateItemBody : ProductId -> Int -> Http.Body
updateItemBody id quantity =
    Http.jsonBody
        (Encode.object
            [ ( "product_id", Encode.int id )
            , ( "quantity", Encode.int quantity )
            ]
        )


fetchCart : Cmd Msg
fetchCart =
    Http.send UpdateCart (Http.get "/cart.json" cartDecoder)


cartDecoder : Decode.Decoder Cart
cartDecoder =
    itemDecoder |> list |> field "items" |> map buildCart


buildCart : List JsonItem -> Cart
buildCart items =
    items
        |> List.map
            (\i ->
                ( i.productId
                , { quantity = i.quantity
                  , name = i.productName
                  , unitPrice = i.unitPrice
                  , subtotal = i.subtotal
                  }
                )
            )
        |> fromList


itemDecoder : Decode.Decoder JsonItem
itemDecoder =
    map5 JsonItem
        (field "productId" int)
        (field "quantity" int)
        (field "productName" string)
        (field "unitPrice" (map parseDecimal string))
        (field "subtotal" (map parseDecimal string))


parseDecimal : String -> Float
parseDecimal str =
    Result.withDefault 0 (String.toFloat str)
