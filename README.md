# README

This is a demo eCommerce application to show how you can integrate Elm with Rails

## Pre-requisites

* Postgres
* Ruby 2.3 (may work with earlier versions, but not tested)
* Elm 0.18

## Setup

Assuming you have all the above, you can first create your database and populate it with some products:

```
rake db:setup
```

Start your server with:

```
rails s
```

Then visit `localhost:3000` in your browser and you should be able to start adding items to your cart.

## Application Layout

The elm files are located in `app/assets/elm`.

### Elm tests

Elm tests are located in `spec/elm`.

First install the headless test runner:

```
npm install -g elm-test
```

Then run `elm-test spec/elm/Main.elm` from the project root.

## Stripe

While you will be able to add and remove items from the cart, the checkout form depends on integration with
[Stripe](stripe.com). If you create an account with Stripe and get test keys, you'll be able to use the checkout form
by providing your API keys to the application as environment variables (remember to use TEST keys when playing
with the app in development):

```
STRIPE_PUBLISHABLE_KEY="<Your publishable key>" STRIPE_KEY="<Your API key>" rails s
```

Stripe provides some test credit cards that will behave in a predictable way when using TEST API keys:

* 4242424242424242 : Successful payment (use a valid expiry date in the future and any CVC code)
* 4000000000000002 : Card declined

Others can be found in [the Stripe documentation](https://stripe.com/docs/testing#cards).
