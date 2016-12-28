require 'spec_helper'
require 'presenters/order_presenter'

RSpec.describe OrderPresenter do
  let(:order) { double(id: 4, items: [item_1, item_2], total: 246.00) }
  let(:product_1) { double(id: 1, name: "Aged Brie", unit_price: 123.00) }
  let(:product_2) { double(id: 2, name: "Sulfuras", unit_price: 50.00) }
  let(:item_1) { double(quantity: 1, product: product_1, subtotal: 123.00) }
  let(:item_2) { double(quantity: 2, product: product_2, subtotal: 100.00) }

  describe '#as_json' do
    it 'represents the cart as json' do
      presenter = OrderPresenter.new(order)

      expect(presenter.as_json).to eq({
        id: 4,
        items: [
          { productId: 1, productName: "Aged Brie", quantity: 1, unitPrice: 123.00, subtotal: 123.00 },
          { productId: 2, productName: "Sulfuras", quantity: 2, unitPrice: 50.00, subtotal: 100.00 }
        ],
        total: 246.00
      })
    end
  end
end
