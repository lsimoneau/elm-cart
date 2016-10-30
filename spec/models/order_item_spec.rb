require 'rails_helper'

RSpec.describe OrderItem do
  describe "#subtotal" do
    it "calculates the subtotal based on the quantity and unit_price of the product" do
      product = Product.create(unit_price: 50.0)
      order = Order.create
      order_item = OrderItem.create(product: product, order: order, quantity: 3)
      expect(order_item.subtotal).to eq 150.0
    end
  end
end
