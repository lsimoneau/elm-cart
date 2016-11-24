module ShoppingCart exposing (..)

import ShoppingCart.Types exposing (..)
import ShoppingCart.Api exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Dict exposing (fromList, toList)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Round exposing (round)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL

init : ( Model, Cmd Msg )
init =
    ( { loading = False
      , cart = []
      }
    , fetchCart
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment productId ->
            ( model, updateItem productId 1 )

        Decrement productId ->
            ( model, updateItem productId -1 )

        UpdateCart (Ok cart) ->
            ( { model | cart = cart }, Cmd.none )

        UpdateCart (Err _) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    section [ class "section" ]
        [ div [] (List.map itemView model.cart) ]


itemView : Item -> Html Msg
itemView item =
    div [ class "box" ]
        [ article [ class "product media" ]
            [ div [ class "content" ]
                [ div [] [ text item.name ]
                , div [] [ toString item.quantity |> text ]
                , div [] [ dollars item.subtotal |> text ]
                , button [ onClick (Decrement item.productId) ] [ text "-" ]
                , button [ onClick (Increment item.productId) ] [ text "+" ]
                ]
            ]
        ]


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n
