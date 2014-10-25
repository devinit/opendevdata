class UnitOfMeasure
  include Mongoid::Document
  include Mongoid::Slug

  field :code, type: String
  field :description, type: String
  # Some possible values (Admin should input this)
  # ==============================================
  # Code | Description
  # U       Unit
  # PC      Percent
  # UGXC    Uganda Shillings (Current)
  # USDC    US Dollars (current)
end
