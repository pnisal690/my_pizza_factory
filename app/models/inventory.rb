class Inventory < ApplicationRecord
  validates :item_type, presence: true
  validates :item_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
