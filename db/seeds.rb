# Users
user1 = User.create(name: 'Alice Johnson', email: 'alice@example.com')
user2 = User.create(name: 'Bob Smith', email: 'bob@example.com')

# Agents
agent1 = Agent.create(name: 'Charlie Brown', license_number: 'ABC123')
agent2 = Agent.create(name: 'Dana White', license_number: 'XYZ789')

# Locations
location1 = Location.create(address: '123 Maple St', city: 'Springfield', state: 'IL', zip_code: '62704')
location2 = Location.create(address: '456 Oak St', city: 'Shelbyville', state: 'IL', zip_code: '62565')

# Properties
property1 = Property.create(name: 'Cozy Cottage', description: 'A charming cottage.', user: user1, agent: agent1, location: location1)
property2 = Property.create(name: 'Modern Apartment', description: 'A sleek downtown apartment.', user: user2, agent: agent2, location: location2)

# Amenities
property1.add_amenity('Fireplace')
property1.add_amenity('Garden')
property2.add_amenity('Gym')
property2.add_amenity('Pool')

# Listings
property1.listings.create(title: 'Cottage Rental', description: 'Available for weekend getaways.', price: 150.00)
property2.listings.create(title: 'Apartment Lease', description: 'Long-term leasing options.', price: 1200.00)

# Reviews
property1.reviews.create(user: user2, content: 'Lovely place!', rating: 4)
property2.reviews.create(user: user1, content: 'Great location!', rating: 5)

# Bookings
property1.book(user2, Date.today, Date.today + 2)
property2.book(user1, Date.today + 10, Date.today + 40)

# Images
property1.add_image('http://example.com/cottage1.jpg')
property1.add_image('http://example.com/cottage2.jpg')
property2.add_image('http://example.com/apartment1.jpg')

# Documents
property1.add_document('Property Deed')
property2.add_document('Rental Agreement')

