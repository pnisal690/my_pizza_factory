class AddCategoryToPizzas < ActiveRecord::Migration[8.0]
  def change
    add_column :pizzas, :category, :string
  end
end
