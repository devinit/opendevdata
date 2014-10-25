class TimeFormat
  include Mongoid::Document
  include Mongoid::Slug

  field :code, type: String
  field :description, type: String
  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # A       Annual
  # Q       Quarterly
  # M       Monthly
end
