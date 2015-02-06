class LocatorsController < ApplicationController

  def generate_geo_records
    possible_names = ['district', 'parish', 'region', 'subcounty', 'village']
    GenerateGeoData.perform_async possible_names
    redirect_to admin_path, alert: 'Your geo-records are being reprocessed'
  end
end
