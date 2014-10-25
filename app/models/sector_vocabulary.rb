class SectorVocabulary
  include Mongoid::Document
  include Mongoid::Slug

  field :code, type: String
  field :description, type: String
  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # 1       MTEF
end
