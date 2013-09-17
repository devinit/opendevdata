class Dataset
  include Mongoid::Document
  mount_uploader :dataset_file, DatasetFileUploader

  field :name, type: String
  field :description, type: String

  belongs_to :organization

  validates :name, :description, presence: true
end
