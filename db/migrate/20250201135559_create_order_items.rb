class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :pizza, null: false, foreign_key: true
      t.references :crust, null: false, foreign_key: true
      t.integer :quantity
      t.string :size
      t.decimal :total_amount
      t.timestamps
    end
  end
end
