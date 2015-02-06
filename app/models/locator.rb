# Just called this locator! :-) 

class Locator
	include Mongoid::Document
	include Mongoid::Geospatial

	field :name, type: String

	# geometry type
	# field :location, type: Point
	geo_field :location # indexes too

	field :route, type: Linestring
	field :area, type: Polygon

	

end