require 'rails_helper'

RSpec.describe Order do
  describe '.for_session' do
    it 'retrieves the order for the provided session' do
      order = Order.create(id: 123)
      session = { cart_id: 123 }
      order = Order.for_session(session)
      expect(order).to eq order
    end

    it 'creates a new order if there is none in the session' do
      session = {}
      order = Order.for_session(session)
      expect(order).to be_an(Order)
    end
  end

  describe "#items" do
    it 'returns an empty collection by default' do
      order = Order.create
      expect(order.items).to be_empty
    end
  end

  describe "#total" do
    it 'returns the total price of the order' do
      order = Order.create
      order.items.create(product: Product.new(unit_price: 20), quantity: 2)
      order.items.create(product: Product.new(unit_price: 15), quantity: 1)
      expect(order.total).to eq 55
    end
  end

  describe '#purchased?' do
    it 'is false if the purchased_at timestamp is nil' do
      order = Order.new(purchased_at: nil)
      expect(order.purchased?).to be false
    end

    it 'is true if the purchased_at timestamp is NOT nil' do
      order = Order.new(purchased_at: Date.today)
      expect(order.purchased?).to be true
    end
  end
end
