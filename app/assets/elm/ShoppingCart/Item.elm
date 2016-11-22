module ShoppingCart.Item exposing (..)


type alias ProductId =
    Int


type alias Item =
    { quantity : Int
    , name : String
    , unitPrice : Float
    , subtotal : Float
    }
