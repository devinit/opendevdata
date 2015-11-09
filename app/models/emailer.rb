class Emailer
  #TODO -> GEOIP to track IP address and location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :content, type: String
end
