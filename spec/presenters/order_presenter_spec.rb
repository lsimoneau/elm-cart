require 'spec_helper'
require 'presenters/order_presenter'

RSpec.describe OrderPresenter do
  let(:order) { double(id: 4, items: [item_1, item_2], total: 246.00) }
  let(:item_1) { double(quantity: 1, unit_price: 123.00, subtotal: 123.00) }
  let(:item_2) { double(quantity: 2, unit_price: 50.00, subtotal: 100.00) }

  describe '#as_json' do
    it 'represents the cart as json' do
      presenter = OrderPresenter.new(order)

      expect(presenter.as_json).to eq({
        id: 4,
        items: [
          { quantity: 1, unit_price: 123.00, subtotal: 123.00 },
          { quantity: 2, unit_price: 50.00, subtotal: 100.00 }
        ]
      })
    end
  end
end
