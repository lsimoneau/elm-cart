require 'rails_helper'

RSpec.describe "Shopping cart" do
  before do
    Product.create(
      name: "Sulfuras, Hand of Ragnaros",
      unit_price: 999.00
    )
  end

  it "can add items to the cart" do
    visit "/products"

    save_and_open_page
    within("article.product", text: "Sulfuras") do
      click_link("Add to Cart")
    end
    expect(page).to have_content("My Cart (1)")
  end
end
