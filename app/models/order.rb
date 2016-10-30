class Order < ApplicationRecord
  def self.for_session(session)
    if session[:cart_id]
      Order.find(session[:cart_id])
    else
      Order.create
    end
  end

  def items
    []
  end

  def purchased?
    purchased_at.present?
  end
end
