class ImageService
  def self.add_image(property, url)
    property.images.create(url: url)
  end
end