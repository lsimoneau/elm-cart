class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
  end
end
