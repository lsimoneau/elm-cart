module ShoppingCart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Dict exposing (fromList, toList)
import ShoppingCart.Item exposing (..)
import ShoppingCart.Cart exposing (..)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { loading : Bool
    , cart : Cart
    }


init : (Model, Cmd Msg)
init =
    ({ loading = False
    , cart =
        fromList
            [ ( 123, { quantity = 1, unitPrice = 99.0, subtotal = 99.0, name = "Sulfuras, Hand of Ragnaros" } )
            ]
    }, Cmd.none)



-- UPDATE


type Msg
    = Increment ProductId
    | Decrement ProductId
    | CartLoaded (Result Http.Error String)
    | RequestSucceed String
    | RequestFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment productId ->
            ({ model | cart = incrementProduct productId model.cart }, Cmd.none)

        Decrement productId ->
            ({ model | cart = decrementProduct productId model.cart }, Cmd.none)

        RequestSucceed response ->
            (model, Cmd.none)

        RequestFail error ->
            (model, Cmd.none)

        CartLoaded (Ok json) ->
            (model, Cmd.none)

        CartLoaded (Err _) ->
            (model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [] (List.map itemView (toList model.cart))


itemView : ( ProductId, Item ) -> Html Msg
itemView ( productId, item ) =
    div []
        [ div [] [ text item.name ]
        , div [] [ toString item.quantity |> text ]
        , button [ onClick (Decrement productId) ] [ text "-" ]
        , button [ onClick (Increment productId) ] [ text "+" ]
        ]



-- HTTP


loadCart : Cmd Msg
loadCart =
  let
    url =
      "/cart.json"

  in
     Http.send CartLoaded (Http.get url decodeCart)
