class LocatorsController < ApplicationController

  def generate_geo_records
    # Worst place to do all this magic, but makes sense to
    # onboard data that is static once
    possible_names = ['district', 'parish', 'region', 'subcounty', 'village']
    units_of_measure = [
      ['U', 'Unit'],
      ['PC', "Percent"],
      ["UGXC", "Uganda Shillings (Current)"],
      ["USDC", "US Dollars (Current)"]
    ]
    GenerateStaticData.perform_async possible_names, units_of_measure
    redirect_to admin_path, notice: 'Your geo-records are being reprocessed'
  end
end
