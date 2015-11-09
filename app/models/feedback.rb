class Feedback
  #TODO -> GEOIP to track IP address and location
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid
  field :country, type: String
  field :remarks, type: String
  field :first_name, type: String
  field :last_name, type: String
  # field :gender, type: String
  as_enum :gender, female: 1, male: 0
  belongs_to :open_workspace
  belongs_to :dataset
end
