class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.timestamp :purchased_at

      t.timestamps
    end
  end
end
