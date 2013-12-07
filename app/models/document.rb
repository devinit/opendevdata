class Document
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  validates :name, :description, presence: true

  mount_uploader :upload, DocumentUploader
end
