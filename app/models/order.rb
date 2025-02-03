class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :order_sides, dependent: :destroy

  has_many :pizzas, through: :order_items
  validates :customer_name, presence: true
  validates :status, inclusion: { in: %w[pending confirmed delivered cancelled] }

  before_create :validate_business_rules, :check_inventory
  before_save :calculate_total_price

  def calculate_total_price
    pizza_price = order_items.sum { |item| item.pizza.price_for_size(item.size) }
    topping_price = order_items.sum { |item| item.toppings.sum(&:price) }
    side_price = order_sides.sum { |item| item.side.price * item.quantity }

    self.total_amount = pizza_price + topping_price + side_price
  end

  def validate_business_rules
    order_items.each do |item|
      # Business rule: Vegetarian pizzas can't have non-vegetarian toppings
      if item.pizza.category == 'vegetarian' && item.toppings.any? { |t| t.is_vegetarian == 0 }
        errors.add(:base, 'Vegetarian pizza cannot have non-vegetarian toppings')
      end

      # Business rule: Non-vegetarian pizzas can't have paneer topping
      if item.pizza.category == 'non-vegetarian' && item.toppings.any? { |t| t.name == 'Paneer' }
        errors.add(:base, 'Non-vegetarian pizza cannot have paneer topping')
      end

      # Business rule: Only one type of crust per pizza
      if order_items.select { |i| i.pizza_id == item.pizza_id }.count > 1
        errors.add(:base, 'Only one type of crust can be selected per pizza')
      end

      # Business rule: Large pizzas can have 2 free toppings
      errors.add(:base, 'Large pizzas can only have 2 free toppings') if item.size == 'Large' && item.toppings.count > 2

      # Business rule: Only one non-veg topping in non-veg pizza
      if item.pizza.category == 'non-vegetarian' && item.toppings.select { |t| t.is_vegetarian == 0 }.count > 1
        errors.add(:base, 'You can add only one non-veg topping to a non-vegetarian pizza')
      end
    end
    throw(:abort) if errors.present?
  end

  def check_inventory
    inventory_errors = []

    # Check inventory for pizzas and crusts
    order_items.each do |item|
      # Check pizza inventory
      pizza_inventory = Inventory.find_by(item_type: 'Pizza', item_id: item.pizza_id)
      if pizza_inventory.nil? || pizza_inventory.quantity < item.quantity
        inventory_errors << "Not enough inventory for pizza: #{item.pizza.name}"
      end

      # Check crust inventory
      crust_inventory = Inventory.find_by(item_type: 'Crust', item_id: item.crust.id)
      if crust_inventory.nil? || crust_inventory.quantity < item.quantity
        inventory_errors << "Not enough inventory for crust: #{item.crust.name}"
      end

      # Check toppings inventory
      item.toppings.each do |topping|
        topping_inventory = Inventory.find_by(item_type: 'Topping', item_id: topping.id)
        if topping_inventory.nil? || topping_inventory.quantity < item.quantity
          inventory_errors << "Not enough inventory for topping: #{topping.name}"
        end
      end
    end

    # Check inventory for side orders
    order_sides.each do |side|
      side_inventory = Inventory.find_by(item_type: 'Side', item_id: side.side_id)
      if side_inventory.nil? || side_inventory.quantity < side.quantity
        inventory_errors << "Not enough inventory for side: #{side.side.name}"
      end
    end

    return unless inventory_errors.any?

    errors.add(:base, inventory_errors.join(', '))
    throw(:abort) # Prevents order from being created
  end

  def confirm_order!
    return false unless valid?

    # Reduce inventory
    order_items.each do |item|
      inventory = Inventory.find_by(item_type: 'Pizza', item_id: item.pizza_id)

      inventory.update(quantity: inventory.quantity - 1)

      inventory = Inventory.find_by(item_type: 'Crust', item_id: item.crust_id)
      inventory.update(quantity: inventory.quantity - 1)

      item.toppings.each do |topping|
        inventory = Inventory.find_by(item_type: 'Topping', item_id: topping.id)
        inventory.update(quantity: inventory.quantity - 1)
      end
    end

    order_sides.each do |side|
      inventory = Inventory.find_by(item_type: 'Side', item_id: side.side_id)
      inventory.update(quantity: inventory.quantity - 1)
    end

    update(status: 'confirmed')
    true
  end
end
