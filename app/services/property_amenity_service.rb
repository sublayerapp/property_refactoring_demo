class PropertyAmenityService
  def self.add_amenity_to_property(property, amenity)
    PropertyAmenity.find_or_create_by(property: property, amenity: amenity)
  end

  def self.remove_amenity_from_property(property, amenity)
    PropertyAmenity.where(property: property, amenity: amenity).destroy_all
  end

  def self.properties_with_amenity(amenity_name)
    Amenity.find_by(name: amenity_name)&.properties
  end
end