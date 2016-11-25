class PaymentsController < ApplicationController
  def create
    token = params[:card_token]
    cart = Order.find(session[:cart_id])

    charge = Stripe::Charge.create(
      amount: 1000,
      currency: 'aud',
      description: 'buying stuff',
      source: token
    )

    render json: charge
  rescue Stripe::CardError => e
    render json: { paid: false, error: e.message }, status: 402
  end
end
