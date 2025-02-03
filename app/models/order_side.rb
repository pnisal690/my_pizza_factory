class OrderSide < ApplicationRecord
  belongs_to :order
  belongs_to :side
  validates :quantity, numericality: { greater_than: 0 }
end
