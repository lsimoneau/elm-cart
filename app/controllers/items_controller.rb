class ItemsController < ApplicationController
  def create
    order = Order.for_session(session)
    session[:cart_id] = order.id

    AddToCart.call(order, item_params)

    presenter = OrderPresenter.new(order)
    render json: presenter
  end

  private

  def item_params
    params.require(:item).permit(:quantity, :product_id)
  end
end
