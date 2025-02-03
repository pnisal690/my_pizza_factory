class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :pizza
  belongs_to :crust

  has_many :order_item_toppings, dependent: :destroy
  has_many :toppings, through: :order_item_toppings

  validates :size, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
