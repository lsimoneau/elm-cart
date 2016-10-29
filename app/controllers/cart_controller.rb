class CartController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.json { render json: { items: [] } }
    end
  end
end
