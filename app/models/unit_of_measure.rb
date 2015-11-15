class UnitOfMeasure
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :code, type: String
  field :description, type: String

  validates :code, presence: true, uniqueness: true
  validates :description, presence: true

  # belongs_to :measureable_unit, class_name: "DataSerie", inverse_of: :unit_of_measure
  belongs_to :data_serie
  # embedded_in :data_serie

  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # U       Unit
  # PC      Percent
  # UGXC    Uganda Shillings (Current)
  # USDC    US Dollars (current)
end
