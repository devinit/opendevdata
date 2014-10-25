class MtefSector
  include Mongoid::Document
  include Mongoid::Slug

  field :code, type: String
  field :description, type: String
  # Some possible values (Admin should input this)
  # ==============================================
  # Code| Description
  # 01  Agriculture
  # 02  Lands, Housing and Urban Development
  # 03  Energy
  # 04  Works and Transport
  # 05  Information and Communication Technology
  # 06  Tourism, Trade and Industry
  # 07  Education
  # 08  Health
  # 09  Water and Environment
  # 10  Social Development
  # 11  Security
  # 12  Justice, Law and Order
  # 13  Public Sector Management
  # 14  Accountability
  # 15  Legislature
  # 16  Public Administration
  # 17  Interest Payments

end
