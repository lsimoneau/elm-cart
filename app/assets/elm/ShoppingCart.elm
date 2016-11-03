module ShoppingCart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.App as App

import Dict exposing (fromList, toList)

import ShoppingCart.Item exposing (..)
import ShoppingCart.Cart exposing (..)

main =
  App.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { loading: Bool
  , cart: Cart
  }

model : Model
model = { loading = False, cart = fromList [
    (123, { quantity = 1, unit_price = 99.0, subtotal = 99.0, name = "Sulfuras, Hand of Ragnaros" })
  ]}


-- UPDATE

type Msg
  = Increment ProductId
  | Decrement ProductId

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment productId ->
      { model | cart = incrementProduct productId model.cart }
    Decrement productId ->
      model


-- VIEW

view : Model -> Html Msg
view model =
  div [] (List.map itemView (toList model.cart))

itemView : (ProductId, Item) -> Html Msg
itemView (productId, item) =
  div [] [
    div [] [ text item.name ]
  , div [] [ toString item.quantity |> text ]
  , button [ onClick (Decrement productId) ] [ text "-" ]
  , button [ onClick (Increment productId) ] [ text "+" ]
  ]
