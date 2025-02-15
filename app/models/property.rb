class Property < ApplicationRecord
  belongs_to :user
  belongs_to :agent
  belongs_to :location

  has_many :property_amenities
  has_many :amenities, through: :property_amenities
  has_many :listings
  has_many :reviews
  has_many :bookings
  has_many :images
  has_many :documents

  scope :by_city, ->(city) { joins(:location).where(locations: { city: city }) }
  scope :by_price_range, ->(min, max) { joins(:listings).where(listings: { price: min..max }) }
  scope :with_amenity, ->(amenity_name) { PropertyAmenityService.properties_with_amenity(amenity_name) }
  scope :top_rated, -> { joins(:reviews).group('properties.id').order('AVG(reviews.rating) DESC') }

  def book(user, start_date, end_date)
    bookings.create(user: user, start_date: start_date, end_date: end_date)
  end

  def add_amenity(amenity_name)
    amenity = Amenity.find_or_create_by(name: amenity_name)
    PropertyAmenityService.add_amenity_to_property(self, amenity)
  end

  def average_rating
    reviews.average(:rating)
  end

  def total_bookings
    bookings.count
  end

  def add_image(url)
    images.create(url: url)
  end

  def add_document(file_name)
    documents.create(file_name: file_name)
  end
end