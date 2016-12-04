module ShoppingCart.View exposing (view)

import ShoppingCart.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Round exposing (round)


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
    div
        [ class
            (if model.checkingOut then
                "modal is-active"
             else
                "modal"
            )
        ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ] [ text "Checkout" ] ]
            , section [ class "modal-card-body" ]
                [ checkoutForm model ]
            , footer [ class "modal-card-foot" ]
                [ a
                    [ class
                        (if model.formSubmitting then
                            "button is-primary is-loading"
                         else
                            "button is-primary"
                        )
                    , onClick Checkout
                    ]
                    [ text "Checkout" ]
                , a [ class "button", onClick CancelCheckout ] [ text "Cancel" ]
                ]
            ]
        ]


checkoutForm : Model -> Html Msg
checkoutForm model =
    div []
        [ formError model.paymentError
        , label [ class "label" ] [ text "Card Number" ]
        , p [ class "control has-icon has-icon-left" ]
            [ i [ class "fa fa-credit-card" ] []
            , input [ class "input", type_ "text", onInput UpdateCardNumber ] []
            ]
        , div [ class "columns" ]
            [ div [ class "column" ]
                [ label [ class "label" ] [ text "Expiry" ]
                , p [ class "control has-addons has-icon has-icon-left" ]
                    [ i [ class "fa fa-calendar" ] []
                    , input [ class "input", size 2, maxlength 2, type_ "text", placeholder "MM", onInput UpdateExpMonth ] []
                    , input [ class "input", size 2, maxlength 2, type_ "text", placeholder "YY", onInput UpdateExpYear ] []
                    ]
                ]
            , div [ class "column" ]
                [ label [ class "label" ] [ text "CVC" ]
                , p [ class "control has-icon has-icon-left" ]
                    [ i [ class "fa fa-lock" ] []
                    , input [ class "input", type_ "text", onInput UpdateCvc ] []
                    ]
                ]
            ]
        ]


formError : Maybe String -> Html Msg
formError error =
    case error of
        Just errorText ->
            div [ class "notification is-danger" ] [ text errorText ]

        Nothing ->
            div [] []


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n
