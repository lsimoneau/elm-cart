class OrderPresenter
  def initialize(order)
    @order = order
  end

  def as_json(*args)
    {
      id: order.id,
      items: order.items.map { |item|
        ItemPresenter.new(item).as_json
      }
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
        quantity: item.quantity,
        unit_price: item.unit_price,
        subtotal: item.subtotal
      }
    end

    private

    attr_reader :item
  end
end
