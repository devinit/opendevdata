# Just called this locator! :-)

class Locator
	include Mongoid::Document
	include Mongoid::Geospatial
  include Mongoid::Timestamps


	field :name, type: String

	# Specific/experimment fields
	# Village Code,Village,Parish Code,Parish,Sub-County Code,Sub-County,District Code,District
	field :village_code, type: String
	field :village, type: String
	field :parish_code, type: String
	field :subcounty, type: String
	field :subcounty_code, type: String
	field :district, type: String
	field :district_code, type: String
	field :region_code, type: String
	field :region, type: String

	# geometry type
	# field :location, type: Point
	geo_field :location # indexes too

	# field :route, type: Linestring #TOFIX -> Linestring unrecognizable
	field :area, type: Polygon
	belongs_to :location_type
end
