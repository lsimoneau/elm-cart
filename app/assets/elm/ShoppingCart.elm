module ShoppingCart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Dict exposing (fromList, toList)
import ShoppingCart.Item exposing (..)
import ShoppingCart.Cart exposing (..)
import Json.Decode as Decode exposing (..)
import Dict.Extra exposing (..)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { loading : Bool
    , cart : Cart
    }


init : (Model, Cmd Msg)
init =
    (
      { loading = False
      , cart = fromList []
      }
    , fetchCart)



-- UPDATE


type Msg
    = Increment ProductId
    | Decrement ProductId
    | LoadCart (Result Http.Error Cart)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment productId ->
            ({ model | cart = incrementProduct productId model.cart }, Cmd.none)

        Decrement productId ->
            ({ model | cart = decrementProduct productId model.cart }, Cmd.none)

        LoadCart (Ok cart) ->
            ({ model | cart = cart }, Cmd.none)

        LoadCart (Err _) ->
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


fetchCart : Cmd Msg
fetchCart =
  Http.send LoadCart (Http.get "/cart.json" decodeCart)


type alias JsonItem =
  { productId: Int, quantity: Int, productName: String, unitPrice: Float, subtotal: Float }


decodeCart : Decode.Decoder Cart
decodeCart =
  Decode.map buildCart (Decode.field "items" (Decode.list decodeItem))


buildCart : List JsonItem -> Cart
buildCart items =
  Dict.fromList (List.map (\i ->
    (i.productId, { quantity = i.quantity, name = i.productName, unitPrice = i.unitPrice, subtotal = i.subtotal })
  ) items)


decodeItem : Decode.Decoder JsonItem
decodeItem =
  Decode.map5 JsonItem
    (Decode.field "productId" Decode.int)
    (Decode.field "quantity" Decode.int)
    (Decode.field "productName" Decode.string)
    (Decode.field "unitPrice" (Decode.map parseDecimal Decode.string))
    (Decode.field "subtotal" (Decode.map parseDecimal Decode.string))


parseDecimal : String -> Float
parseDecimal str =
  Result.withDefault 0 (String.toFloat str)
