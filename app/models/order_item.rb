class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def subtotal
    product.unit_price * quantity
  end
end
