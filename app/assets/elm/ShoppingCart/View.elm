module ShoppingCart.View exposing (view)

import ShoppingCart.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Round exposing (round)


view : Model -> Html Msg
view model =
    section [ class "section" ]
        [ if model.status == CompletedCheckout then
            successView
          else
            cartView model
        ]


successView : Html Msg
successView =
    div [ class "message is-success" ]
        [ div [ class "message-body" ]
            [ text "Your payment was successful. Check your email for order details."
            ]
        ]


cartView : Model -> Html Msg
cartView model =
    div [ class "columns" ]
        [ div [ class "column is-two-thirds" ]
            [ errorMessage model.cartError
            , div [] (List.map itemView model.cart.items)
            ]
        , div [ class "column" ]
            [ nav [ class "panel" ]
                [ div [ class "panel-block" ]
                    [ strong [] [ text ("Total: " ++ (dollars model.cart.total)) ]
                    ]
                , div [ class "panel-block" ]
                    [ a [ class "button is-primary", onClick GoToCheckout ] [ text "Checkout" ]
                    ]
                ]
            ]
        , checkoutDialog model
        ]


itemView : Item -> Html Msg
itemView item =
    div [ class "box" ]
        [ article [ class "product media" ]
            [ figure [ class "media-left" ]
                [ p [ class "image is-96x96" ]
                    [ img [ src "http://placehold.it/192x192" ]
                        []
                    ]
                ]
            , div [ class "media-content" ]
                [ div [ class "columns" ]
                    [ div [ class "column is-half" ]
                        [ div [] [ text item.name ]
                        , strong [] [ dollars item.unitPrice |> text ]
                        ]
                    , div [ class "column" ]
                        [ p [ class "control has-addons" ]
                            [ button [ class "button", onClick (Decrement item.productId) ] [ text "-" ]
                            , input [ disabled True, size 2, class "input", value (toString item.quantity) ] []
                            , button [ class "button", onClick (Increment item.productId) ] [ text "+" ]
                            ]
                        ]
                    , div [ class "column" ]
                        [ strong [] [ dollars item.subtotal |> text ] ]
                    ]
                ]
            ]
        ]


checkoutDialog : Model -> Html Msg
checkoutDialog model =
    div
        [ class
            (if showCheckoutForm model then
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
                        (if model.status == SubmittingCheckoutForm then
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


showCheckoutForm : Model -> Bool
showCheckoutForm model =
    model.status == SubmittingCheckoutForm || model.status == ViewingCheckoutForm


checkoutForm : Model -> Html Msg
checkoutForm model =
    div []
        [ errorMessage model.paymentError
        , label [ class "label" ] [ text "Card Number" ]
        , p [ class "control has-icon has-icon-left" ]
            [ i [ class "fa fa-credit-card" ] []
            , input [ class "input", type_ "text", onInput UpdateCardNumber ] []
            ]
        , div [ class "columns" ]
            [ div [ class "column is-one-quarter" ]
                [ label [ class "label" ] [ text "Expiry" ]
                , p [ class "control has-addons has-icon has-icon-left" ]
                    [ i [ class "fa fa-calendar" ] []
                    , input [ class "input", size 2, maxlength 2, type_ "text", placeholder "MM", onInput UpdateExpMonth ] []
                    , input [ class "input", size 2, maxlength 2, type_ "text", placeholder "YY", onInput UpdateExpYear ] []
                    ]
                ]
            , div [ class "column is-one-quarter" ]
                [ label [ class "label" ] [ text "CVC" ]
                , p [ class "control has-icon has-icon-left" ]
                    [ i [ class "fa fa-lock" ] []
                    , input [ class "input", type_ "text", onInput UpdateCvc ] []
                    ]
                ]
            ]
        ]


errorMessage : Maybe String -> Html Msg
errorMessage error =
    case error of
        Just errorText ->
            div [ class "notification is-danger" ] [ text errorText ]

        Nothing ->
            div [] []


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n
