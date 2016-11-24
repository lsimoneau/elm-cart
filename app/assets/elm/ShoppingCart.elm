module ShoppingCart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Dict exposing (fromList, toList)
import ShoppingCart.Item exposing (..)
import ShoppingCart.Cart exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Dict.Extra exposing (..)
import Round exposing (round)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { loading : Bool
    , cart : Cart
    }


init : ( Model, Cmd Msg )
init =
    ( { loading = False
      , cart = fromList []
      }
    , fetchCart
    )



-- UPDATE


type Msg
    = Increment ProductId
    | Decrement ProductId
    | UpdateCart (Result Http.Error Cart)


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
        [ div [] (List.map itemView (toList model.cart)) ]


itemView : ( ProductId, Item ) -> Html Msg
itemView ( productId, item ) =
    div [ class "box" ]
        [ article [ class "product media" ]
            [ div [ class "content" ]
                [ div [] [ text item.name ]
                , div [] [ toString item.quantity |> text ]
                , div [] [ dollars item.subtotal |> text ]
                , button [ onClick (Decrement productId) ] [ text "-" ]
                , button [ onClick (Increment productId) ] [ text "+" ]
                ]
            ]
        ]


dollars : Float -> String
dollars n =
    "$" ++ Round.round 2 n



-- HTTP


updateItem : ProductId -> Int -> Cmd Msg
updateItem id quantity =
    Http.send UpdateCart (Http.post "/cart/items" (Http.jsonBody (Encode.object [ ( "product_id", Encode.int id ), ( "quantity", Encode.int quantity ) ])) decodeCart)


fetchCart : Cmd Msg
fetchCart =
    Http.send UpdateCart (Http.get "/cart.json" decodeCart)


type alias JsonItem =
    { productId : Int, quantity : Int, productName : String, unitPrice : Float, subtotal : Float }


decodeCart : Decode.Decoder Cart
decodeCart =
    Decode.map buildCart (Decode.field "items" (Decode.list decodeItem))


buildCart : List JsonItem -> Cart
buildCart items =
    Dict.fromList
        (List.map
            (\i ->
                ( i.productId, { quantity = i.quantity, name = i.productName, unitPrice = i.unitPrice, subtotal = i.subtotal } )
            )
            items
        )


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
