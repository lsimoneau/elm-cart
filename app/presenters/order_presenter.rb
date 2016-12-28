class OrderPresenter
  def initialize(order)
    @order = order
  end

  def as_json(*args)
    {
      id: order.id,
      items: order.items.map { |item|
        ItemPresenter.new(item).as_json
      },
      total: order.total
    }
  end

  private

  attr_reader :order

  class ItemPresenter
    def initialize(item)
      @item = item
    end

    def as_json
      {
        productId: item.product.id,
        productName: item.product.name,
        quantity: item.quantity,
        unitPrice: item.product.unit_price,
        subtotal: item.subtotal
      }
    end

    private

    attr_reader :item
  end
end
