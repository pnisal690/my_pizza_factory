class Pizza < ApplicationRecord
  belongs_to :crust
  has_many :order_items
  has_many :orders, through: :order_items

  validates :category, presence: true, inclusion: { in: %w[vegetarian non-vegetarian] }
  validates :name, presence: true, uniqueness: true
  validates :price_regular, :price_medium, :price_large, presence: true, numericality: { greater_than: 0 }

  def price_for_size(size)
    case size.downcase
    when 'regular'
      price_regular
    when 'medium'
      price_medium
    when 'large'
      price_large
    else
      raise ArgumentError, "Invalid size: #{size}"
    end
  end
end
