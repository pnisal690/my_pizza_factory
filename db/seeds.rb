# Clear existing data
OrderItem.delete_all
Order.delete_all
Inventory.delete_all
Topping.delete_all
Side.delete_all
Pizza.delete_all
Crust.delete_all

# Create Crusts
crusts = ['New hand tossed', 'Wheat thin crust', 'Cheese Burst', 'Fresh pan pizza'].map do |crust_name|
  Crust.create!(name: crust_name, price: 0)
end

# Create Pizzas
pizzas = [
  { name: 'Deluxe Veggie', prices: [150, 200, 325], category: 'vegetarian' },
  { name: 'Cheese and corn', prices: [175, 375, 475], category: 'vegetarian' },
  { name: 'Paneer Tikka', prices: [160, 290, 340], category: 'vegetarian' },
  { name: 'Non-Veg Supreme', prices: [190, 325, 425], category: 'non-vegetarian' },
  { name: 'Chicken Tikka', prices: [210, 370, 500], category: 'non-vegetarian' },
  { name: 'Pepper Barbecue Chicken', prices: [220, 380, 525], category: 'non-vegetarian' }
].map do |pizza|
  Pizza.create!(
    name: pizza[:name],
    price_regular: pizza[:prices][0],
    price_medium: pizza[:prices][1],
    price_large: pizza[:prices][2],
    category: pizza[:category],
    crust_id: crusts.first.id
  )
end

# Create Toppings
veg_toppings = [
  { name: 'Black olive', price: 20 },
  { name: 'Capsicum', price: 25 },
  { name: 'Paneer', price: 35 },
  { name: 'Mushroom', price: 30 },
  { name: 'Fresh tomato', price: 10 }
].map { |t| Topping.create!(name: t[:name], price: t[:price], is_vegetarian: true) }

non_veg_toppings = [
  { name: 'Chicken tikka', price: 35 },
  { name: 'Barbeque chicken', price: 45 },
  { name: 'Grilled chicken', price: 40 }
].map { |t| Topping.create!(name: t[:name], price: t[:price], is_vegetarian: false) }

Topping.create!(name: 'Extra cheese', price: 35, is_vegetarian: true)

# Create Sides
sides = [
  { name: 'Cold drink', price: 55 },
  { name: 'Mousse cake', price: 90 }
].map { |side| Side.create!(name: side[:name], price: side[:price]) }

# Seed Inventory
(pizzas + veg_toppings + non_veg_toppings + sides + crusts).each do |item|
  Inventory.create!(item_type: item.class.name, item_id: item.id, quantity: 100)
end

puts 'Seeding complete!'
