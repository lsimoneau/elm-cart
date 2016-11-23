class AddToCart
  attr_reader :order, :item_params

  def initialize(order, item_params)
    @order = order
    @item_params = item_params
  end

  def call
    existing_item = order.items.find_by(product_id: item_params[:product_id])
    if existing_item
      existing_item.update(quantity: existing_item.quantity + item_params[:quantity].to_i)
    else
      order.items.create(item_params)
    end
  end

  def self.call(*args)
    self.new(*args).call
  end
end
