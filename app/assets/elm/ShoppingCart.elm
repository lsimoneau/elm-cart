port module ShoppingCart exposing (..)

import ShoppingCart.Types exposing (..)
import ShoppingCart.Api exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
      , cardDetails = emptyCard
      , formSubmitting = False
      , paymentError = Nothing
      , cart = []
      }
    , fetchCart
    )


emptyCard : CardDetails
emptyCard =
  { number = "", exp_month = "", exp_year = "", cvc = "" }



-- UPDATE


port checkout : CardDetails -> Cmd msg


port cardToken : (String -> msg) -> Sub msg


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

        PaymentSubmitted (Ok True) ->
            ( { model | formSubmitting = False, paymentError = Nothing }, Cmd.none )

        -- Got response from server, but charge has { paid: false }
        PaymentSubmitted (Ok False) ->
            ( { model | formSubmitting = False, paymentError = Just "Oops, something went wrong" }, Cmd.none )

        PaymentSubmitted (Err response) ->
            ( model, Cmd.none )

        Checkout ->
            ( { model | formSubmitting = True } , checkout model.cardDetails )

        UpdateCardNumber value ->
            ( { model | cardDetails = updateCardNumber value model.cardDetails }, Cmd.none )

        UpdateExpMonth value ->
            ( { model | cardDetails = updateExpMonth value model.cardDetails }, Cmd.none )

        UpdateExpYear value ->
            ( { model | cardDetails = updateExpYear value model.cardDetails }, Cmd.none )

        UpdateCvc value ->
            ( { model | cardDetails = updateCvc value model.cardDetails }, Cmd.none )

        GetCardToken token ->
            ( model, submitPayment token )


updateCardNumber : String -> CardDetails -> CardDetails
updateCardNumber value details =
    { details | number = value }


updateExpMonth : String -> CardDetails -> CardDetails
updateExpMonth value details =
    { details | exp_month = value }


updateExpYear : String -> CardDetails -> CardDetails
updateExpYear value details =
    { details | exp_year = value }

updateCvc : String -> CardDetails -> CardDetails
updateCvc value details =
    { details | cvc = value }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    cardToken GetCardToken



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
                            , input [ class "input", size 2, type_ "text", placeholder "MM", onInput UpdateExpMonth ] []
                            , input [ class "input", size 2, type_ "text", placeholder "YY", onInput UpdateExpYear ] []
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
            , footer [ class "modal-card-foot" ]
                [ a [ class (if model.formSubmitting then "button is-primary is-loading" else "button is-primary"), onClick Checkout ] [ text "Checkout" ]
                , a [ class "button", onClick CancelCheckout ] [ text "Cancel" ]
                ]
            ]
        ]


formError : Maybe String -> Html Msg
formError error =
  case error of
    Just errorText -> div [ class "notification is-danger" ] [ text errorText ]
    Nothing -> div [] []


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n
