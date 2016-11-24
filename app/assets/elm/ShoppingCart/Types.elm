module ShoppingCart.Types exposing (..)

import Dict exposing (Dict)
import Http exposing (Error)


type Msg
    = Increment ProductId
    | Decrement ProductId
    | UpdateCart (Result Error Cart)


type alias ProductId =
    Int


type alias Item =
    { quantity : Int
    , name : String
    , unitPrice : Float
    , subtotal : Float
    }


type alias Cart =
    Dict ProductId Item
