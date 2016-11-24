module ShoppingCart.Types exposing (..)

import Dict exposing (Dict)
import Http exposing (Error)


type alias Model =
    { loading : Bool
    , checkout : Bool
    , cart : Cart
    }


type Msg
    = Increment ProductId
    | Decrement ProductId
    | UpdateCart (Result Error Cart)
    | GoToCheckout
    | CancelCheckout


type alias ProductId =
    Int


type alias Item =
    { productId: ProductId
    , quantity : Int
    , name : String
    , unitPrice : Float
    , subtotal : Float
    }


type alias Cart =
    List Item
