class Dataset
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :description, type: String
  field :chart_type, type: String
  field :data_extract, type: Hash

  # chart labels
  field :x_label, type: String
  field :y_label, type: String
  field :title, type: String
  field :sub_title, type: String
  field :data_units, type: String  # suffix for tooltip

  mount_uploader :attachment, DatasetFileUploader

  belongs_to :organization

  validates :name, :description, :attachment, :chart_type, :sub_title, :title, presence: true

  has_many :comments
end
