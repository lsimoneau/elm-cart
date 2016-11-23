require "rails_helper"

RSpec.describe AddToCart do
  let!(:sulfuras) { Product.create(name: "Sulfuras") }
  let(:order) { Order.create }

  describe "#call" do
    subject(:call) { AddToCart.call(order, product_id: sulfuras.id, quantity: 1) }

    it "adds an item to the order" do
      expect { call }.to change { order.items.count }.by(1)
    end

    it "increments the quantity of existing items" do
      AddToCart.call(order, product_id: sulfuras.id, quantity: 1)
      expect { call }.to change { order.items.first.quantity }.from(1).to(2)
    end
  end
end
