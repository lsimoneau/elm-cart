require 'rails_helper'

RSpec.describe 'Managing a shopping cart' do
  let(:headers) { { 'Accept' => 'application/json' } }

  describe 'getting the current cart' do
    it 'returns a cart with no items' do
      get '/cart', headers: headers
      expect(response.body).to have_json_size(0).at_path('items')
    end

    context 'with items in the cart' do
      let(:product) { Product.create(name: "Aged Brie", unit_price: 12.00) }

      before do
        post '/cart/items', params: { item: { product_id: product.id, quantity: 3 } }
      end

      it 'returns a cart with items' do
        get '/cart', headers: headers
        expect(response.body).to have_json_size(1).at_path('items')
      end

      describe 'item JSON' do
        it 'has the desired fields' do
          expected = {
            items: [{
              productId: product.id,
              productName: product.name,
              quantity: 3,
              unitPrice: '12.0',
              subtotal: '36.0'
            }]
          }.to_json
          get '/cart', headers: headers
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end

  describe 'adding an item to the cart' do
    it 'returns the populated cart' do
      product = Product.create(name: "Aged Brie", unit_price: 12.00)
      post '/cart/items', params: { item: { product_id: product.id, quantity: 3 } }
      expect(response.body).to have_json_size(1).at_path('items')
    end
  end

  describe 'adding multiple items to the cart' do
    it 'returns the populated cart' do
      brie = Product.create(name: "Aged Brie", unit_price: 12.00)
      sulfuras = Product.create(name: "Sulfuras, Hand of Ragnaros", unit_price: 1000.00)
      post '/cart/items', params: { item: { product_id: brie.id, quantity: 3 } }
      post '/cart/items', params: { item: { product_id: sulfuras.id, quantity: 1 } }
      expect(response.body).to have_json_size(2).at_path('items')
    end
  end

  describe 'increasing the quantity of an item' do
    before do
      brie = Product.create(name: "Aged Brie", unit_price: 12.00)
      post '/cart/items', params: { item: { product_id: brie.id, quantity: 3 } }
      post '/cart/items', params: { item: { product_id: brie.id, quantity: 1 } }
    end

    it 'has one item' do
      expect(response.body).to have_json_size(1).at_path('items')
    end
  end
end
