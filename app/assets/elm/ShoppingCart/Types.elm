module ShoppingCart.Types exposing (..)

import Dict exposing (Dict)
import Http exposing (Error)


type alias Model =
    { loading : Bool
    , cart : Cart
    }


type Msg
    = Increment ProductId
    | Decrement ProductId
    | UpdateCart (Result Error Cart)


type alias ProductId =
    Int


type alias Item =
    { productId: Int
    , quantity : Int
    , name : String
    , unitPrice : Float
    , subtotal : Float
    }


type alias Cart =
    List Item
