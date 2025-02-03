class OrderItemTopping < ApplicationRecord
  belongs_to :order_item
  belongs_to :topping
end
