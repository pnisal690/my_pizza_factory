class CreatePizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :pizzas do |t|
      t.string :name
      t.decimal :price_regular
      t.decimal :price_medium
      t.decimal :price_large
      t.references :crust, null: false, foreign_key: true

      t.timestamps
    end
  end
end
