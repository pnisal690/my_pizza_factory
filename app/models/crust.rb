class Crust < ApplicationRecord
  has_many :pizzas

  validates :name, presence: true, uniqueness: true
end
