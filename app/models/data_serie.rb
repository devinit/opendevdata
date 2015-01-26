class DataSerie
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Taggable

  field :name, type: String
  field :description, type: String
  field :note, type: String
  field :sources, type: String

  slug :name
  has_one :unit_of_measure, class_name: "UnitOfMeasure", inverse_of: :measureable_unit
  # belongs_to :sector

  # field :

  validates :name, :description, :unit_of_measure, presence: true
  #validates :sector_id, presence: true

  # has_many :joined_up_datasets

  # more fields to be added... etc.
end
