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

    within("article.product", text: "Sulfuras") do
      click_link("Add to Cart")
    end
    expect(page).to have_content("My Cart (1)")
  end

  it "can view items in the card" do
    visit "/products"

    within("article.product", text: "Sulfuras") do
      click_link("Add to Cart")
    end
    expect(page).to have_content("My Cart (1)")

    visit "/cart"
    expect(page).to have_content("Sulfuras, Hand of Ragnaros 1")
    expect(page).to have_content("$999.00")
  end

  it "can increase quantity of items in the cart" do
    visit "/products"

    within("article.product", text: "Sulfuras") do
      click_link("Add to Cart")
    end
    expect(page).to have_content("My Cart (1)")

    visit "/cart"

    within("article.product", text: "Sulfuras") do
      click_button("+")
    end
    expect(page).to have_content("Sulfuras, Hand of Ragnaros 2")
    expect(page).to have_content("$1998.00")
  end
end
