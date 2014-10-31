class DataSerie
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String
  field :notes, type: String
  has_one :unit_of_measure
  has_one :sector_vocabulary

  validates :title, :description, presence: true

  # more fields to be added... etc.
end
