class GoogleAnalytics
  #TODO -> GEOIP to track IP address and location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :json, type: Hash
 end
