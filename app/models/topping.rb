class Topping < ApplicationRecord
  has_and_belongs_to_many :pizzas
  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
