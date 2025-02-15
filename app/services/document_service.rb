class DocumentService
  def self.add_document(property, file_name)
    property.documents.create(file_name: file_name)
  end
end