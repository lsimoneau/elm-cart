module ShoppingCart.Types exposing (..)

import Dict exposing (Dict)
import Http exposing (Error)


type Status
    = ViewingCart
    | ViewingCheckoutForm
    | SubmittingCheckoutForm
    | CompletedCheckout


type alias Model =
    { loading : Bool
    , cardDetails : CardDetails
    , status : Status
    , paymentError : Maybe String
    , cartError : Maybe String
    , cart : Cart
    }


type Msg
    = Increment ProductId
    | Decrement ProductId
    | UpdateCart (Result Error Cart)
    | PaymentSubmitted (Result Error Bool)
    | GoToCheckout
    | CancelCheckout
    | Checkout
    | GetCardToken String
    | GetCardError String
    | UpdateCardNumber String
    | UpdateExpMonth String
    | UpdateExpYear String
    | UpdateCvc String


type alias ProductId =
    Int


type alias Item =
    { productId : ProductId
    , quantity : Int
    , name : String
    , unitPrice : Float
    , subtotal : Float
    }


type alias Cart =
    { items : List Item, total : Float }


type alias CardDetails =
    { number : String
    , exp_month : String
    , exp_year : String
    , cvc : String
    }


type alias Charge =
    { paid : Bool }
