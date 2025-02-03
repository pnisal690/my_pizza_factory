# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_250_202_175_256) do
  create_table 'crusts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price', precision: 10
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'inventories', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'item_type'
    t.integer 'item_id'
    t.integer 'quantity'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'order_item_toppings', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'order_item_id', null: false
    t.bigint 'topping_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_item_id'], name: 'index_order_item_toppings_on_order_item_id'
    t.index ['topping_id'], name: 'index_order_item_toppings_on_topping_id'
  end

  create_table 'order_items', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'order_id', null: false
    t.bigint 'pizza_id', null: false
    t.bigint 'crust_id', null: false
    t.integer 'quantity'
    t.string 'size'
    t.decimal 'total_amount', precision: 10
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['crust_id'], name: 'index_order_items_on_crust_id'
    t.index ['order_id'], name: 'index_order_items_on_order_id'
    t.index ['pizza_id'], name: 'index_order_items_on_pizza_id'
  end

  create_table 'order_sides', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'order_id', null: false
    t.bigint 'side_id', null: false
    t.integer 'quantity'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_order_sides_on_order_id'
    t.index ['side_id'], name: 'index_order_sides_on_side_id'
  end

  create_table 'orders', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'customer_name'
    t.string 'status'
    t.decimal 'total_amount', precision: 10
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'pizzas', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price_regular', precision: 10
    t.decimal 'price_medium', precision: 10
    t.decimal 'price_large', precision: 10
    t.bigint 'crust_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'category'
    t.index ['crust_id'], name: 'index_pizzas_on_crust_id'
  end

  create_table 'sides', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price', precision: 10
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'toppings', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price', precision: 10
    t.boolean 'is_vegetarian'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'order_item_toppings', 'order_items'
  add_foreign_key 'order_item_toppings', 'toppings'
  add_foreign_key 'order_items', 'crusts'
  add_foreign_key 'order_items', 'orders'
  add_foreign_key 'order_items', 'pizzas'
  add_foreign_key 'order_sides', 'orders'
  add_foreign_key 'order_sides', 'sides'
  add_foreign_key 'pizzas', 'crusts'
end
