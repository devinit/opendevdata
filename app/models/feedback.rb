class Feedback
  #TODO -> GEOIP to track IP address and location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :remarks, type: String
  field :email, type: String
  field :organisation, type: String
  # field :gender, type: String
  belongs_to :open_workspace
  belongs_to :dataset
end
