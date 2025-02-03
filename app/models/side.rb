class Side < ApplicationRecord
  has_many :order_sides
  has_many :orders, through: :order_sides

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
