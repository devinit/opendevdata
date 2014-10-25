class TimeFormat
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
  # A       Annual
  # Q       Quarterly
  # M       Monthly
end
