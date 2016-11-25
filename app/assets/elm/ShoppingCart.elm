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
      , checkout = False
      , cart = []
      }
    , fetchCart
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToCheckout ->
            ( { model | checkout = True }, Cmd.none )

        CancelCheckout ->
            ( { model | checkout = False }, Cmd.none )

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
        [ div [] (List.map itemView model.cart)
        , a [ class "button is-primary", onClick GoToCheckout ] [ text "Checkout" ]
        , checkoutDialog model
        ]


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


checkoutDialog : Model -> Html Msg
checkoutDialog model =
    div [ class (if model.checkout then "modal is-active" else "modal") ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ] [ text "Checkout" ] ]
            , section [ class "modal-card-body" ]
                [ label [ class "label" ] [ text "Card Number" ]
                , p [ class "control has-icon has-icon-left" ]
                    [ i [ class "fa fa-credit-card" ] []
                    , input [ class "input", type_ "text" ] []
                    ]
                , div [ class "columns" ]
                    [ div [ class "column" ]
                        [ label [ class "label" ] [ text "Expiry" ]
                        , p [ class "control has-icon has-icon-left" ]
                            [ i [ class "fa fa-calendar" ] []
                            , input [ class "input", type_ "text", placeholder "MM/YY" ] []
                            ]
                        ]
                    , div [ class "column" ]
                        [ label [ class "label" ] [ text "CVC" ]
                        , p [ class "control has-icon has-icon-left" ]
                            [ i [ class "fa fa-lock" ] []
                            , input [ class "input", type_ "text" ] []
                            ]
                        ]
                    ]
                ]
            , footer [ class "modal-card-foot" ]
                [ a [ class "button is-primary" ] [ text "Checkout" ]
                , a [ class "button", onClick CancelCheckout ] [ text "Cancel" ]
                ]
            ]
        ]


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n
