class Listing < ApplicationRecord
  belongs_to :property

  scope :by_price_range, ->(min, max) { where(price: min..max) }
end