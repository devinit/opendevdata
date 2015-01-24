class Sector
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :code, type: String
  field :description, type: String
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # 1       MTEF
end
