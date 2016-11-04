module ShoppingCart.Cart exposing (..)

import ShoppingCart.Item exposing (..)
import Dict exposing (..)

type alias Cart = Dict ProductId Item

incrementProduct : ProductId -> Cart -> Cart
incrementProduct productId cart =
  update productId
    (\i -> case i of
      Just item -> Just { item | quantity = item.quantity + 1 }
      Nothing -> Nothing
    ) cart

decrementProduct : ProductId -> Cart -> Cart
decrementProduct productId cart =
  update productId
    (\i -> case i of
      Just item -> Just { item | quantity = item.quantity - 1 }
      Nothing -> Nothing
    ) cart
    |> filter (\id item -> item.quantity > 0)
