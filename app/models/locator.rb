# Just called this locator! :-) 

class Locator
	include Mongoid::Document
	include Mongoid::Geospatial
  include Mongoid::Timestamps


	field :name, type: String

	# geometry type
	# field :location, type: Point
	geo_field :location # indexes too

	# field :route, type: Linestring #TOFIX -> Linestring unrecognizable
	field :area, type: Polygon
	belongs_to :location_type	
end