require 'rails_helper'

RSpec.describe 'Managing a shopping cart' do
  let(:headers) { { 'Accept' => 'application/json' } }

  describe 'getting the current cart' do
    it 'returns a cart with no items' do
      get '/cart', {}, headers
      expect(response.body).to have_json_size(0).at_path('items')
    end
  end
end
