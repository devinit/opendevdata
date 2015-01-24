class DataSerie
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Taggable

  field :name, type: String
  field :description, type: String
  field :notes, type: String
  slug :name
  has_one :unit_of_measure
  belongs_to :sector

  # field :

  validates :name, :description, :sector_id, presence: true

  # has_many :joined_up_datasets

  # more fields to be added... etc.
end
