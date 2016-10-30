class Order < ApplicationRecord
  has_many :items, class_name: :OrderItem

  def self.for_session(session)
    if session[:cart_id]
      Order.find(session[:cart_id])
    else
      Order.create
    end
  end

  def purchased?
    purchased_at.present?
  end
end
