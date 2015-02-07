# encoding: UTF-8

class GenerateGeoData
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform file_names
    # path to folder with geo data csv files
    file_path = "#{Rails.root.to_s}/public/geo_data/"

    logger.info "FILE_NAME #{file_path}"

    file_names.each do |file_name|
      # 'district', 'parish', 'region', 'subcounty', 'village'
      location_type = LocationType.find_or_create_by name: file_name
      temp = SmarterCSV.process "#{file_path}#{file_name}.csv"

      # process large HASh
      # Village Code,Village,Parish Code,Parish,Sub-County Code,Sub-County,District Code,District
      # :district_code,
      # :district_name,
      # :region_code,
      # :region,
      # :parish_code
      # :parish
      # :subcounty

      temp.each do |datum|
        # ideally should be updatable
        # TODO -> prevent over-clicking of nice button
        case file_name

        when 'district'
          # search by district descriptor
          loc = Locator.find_or_create_by district_code: "#{datum[:district_code]}"
          loc.name = datum[:district_name]
          loc.region_code = datum[:region_code]
          loc.location_type = location_type
        when 'parish'
          loc = Locator.find_or_create_by parish_code: "#{datum[:parish_code]}"
          loc.name = datum[:parish]
          # subcounty data
          loc.subcounty_code = datum[:"sub-county_code"]
          loc.subcounty = datum[:"sub-county"]
          # district data
          loc.district_code = datum[:district_code]
          loc.district = datum[:district]
          loc.location_type = location_type
        when 'region'
          loc = Locator.find_or_create_by region_code: "#{datum[:region_code]}"
          loc.name = datum[:region]
          loc.location_type = location_type
        when 'subcounty'
          loc = Locator.find_or_create_by subcounty_code: "#{datum[:'sub-county_code']}"
          loc.subcounty_code = datum[:"sub-county_code"]
          loc.subcounty = datum[:"sub-county"]
          loc.district_code = datum[:district_code]
          loc.district = datum[:district]
          loc.location_type = location_type
          # TODO -> County data
          # we don't have any "formal county data", but this will create it
          # _location_type = LocationType.find_or_create name:
        else
          puts "viola!"
        end
        loc.save if !loc.nil?
      end

      puts "end #{file_name} processing"
    end
  end

end
