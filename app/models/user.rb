class User < ApplicationRecord
  has_many :properties
  has_many :bookings
  has_many :reviews
end
