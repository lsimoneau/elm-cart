port module ShoppingCart exposing (..)

import ShoppingCart.Types exposing (..)
import ShoppingCart.Api exposing (..)
import ShoppingCart.View exposing (..)
import Html exposing (program)
import Http exposing (Error, Response)
import Dict exposing (fromList, toList)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { loading = False
      , status = ViewingCart
      , cartError = Nothing
      , cardDetails = emptyCard
      , paymentError = Nothing
      , cart = { items = [], total = 0.0 }
      }
    , fetchCart
    )


emptyCard : CardDetails
emptyCard =
    { number = "", exp_month = "", exp_year = "", cvc = "" }



-- UPDATE


port checkout : CardDetails -> Cmd msg


port updateCount : Int -> Cmd msg


port cardToken : (String -> msg) -> Sub msg


port cardError : (String -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToCheckout ->
            ( { model | status = ViewingCheckoutForm }, Cmd.none )

        CancelCheckout ->
            ( { model | status = ViewingCart }, Cmd.none )

        Increment productId ->
            ( model, updateItem productId 1 )

        Decrement productId ->
            ( model, updateItem productId -1 )

        UpdateCart (Ok cart) ->
            ( { model | cart = cart }, cart.items |> List.map .quantity |> List.sum |> updateCount )

        UpdateCart (Err error) ->
            ( { model | cartError = Just (handleError error) }, Cmd.none )

        PaymentSubmitted (Ok _) ->
            ( { model | status = CompletedCheckout, paymentError = Nothing }, Cmd.none )

        PaymentSubmitted (Err error) ->
            ( { model | status = ViewingCheckoutForm, paymentError = Just (handleError error) }, Cmd.none )

        Checkout ->
            ( { model | status = SubmittingCheckoutForm }, checkout model.cardDetails )

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

        GetCardError error ->
            ( { model | status = ViewingCheckoutForm, paymentError = Just error }, Cmd.none )


handleError : Error -> String
handleError error =
    case error of
        Http.BadStatus response ->
            Decode.decodeString
                (Decode.field "error" Decode.string)
                response.body
                |> Result.withDefault "Oops. Something went wrong."

        Http.BadPayload error _ ->
            error

        _ ->
            "Oops. Something went wrong."


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
    Sub.batch
        [ cardToken GetCardToken
        , cardError GetCardError
        ]
