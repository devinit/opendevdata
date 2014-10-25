class SpaceFormat
  include Mongoid::Document
  include Mongoid::Slug

  field :code, type: String
  field :description, type: String
  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # 0       Country
  # 1       Region
  # 2       District
  # 3       County
  # 4       Sub-county
  # 5       Parish
  # 6       Village
  # 7       Installation (e.g. School or clinic)
end
