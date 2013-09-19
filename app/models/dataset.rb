class Dataset
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :description, type: String
  mount_uploader :attachment, DatasetFileUploader

  belongs_to :organization

  validates :name, :description, :attachment, presence: true

end
