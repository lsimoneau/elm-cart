class CartController < ApplicationController
  def show
    order = Order.for_session(session)
    presenter = OrderPresenter.new(order)

    respond_to do |format|
      format.html
      format.json { render json: presenter }
    end
  end
end
