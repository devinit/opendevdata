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
  # has_many :units_of_measure, class_name: "UnitOfMeasure", inverse_of: :measureable_unit
  # embeds_one :unit_of_measure
  has_many :units_of_measure, class_name: "UnitOfMeasure"
  # belongs_to :sector

  # field :

  validates :name, :description, presence: true
  #validates :sector_id, presence: true

  # has_many :joined_up_datasets

  # more fields to be added... etc.
end
