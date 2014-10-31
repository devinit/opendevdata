# encoding: UTF-8
require 'faraday'

class ExcelToJson
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform dataset_id, tempfile_path, chart_type, file_name
    logger.debug "---- ***** ---- *** ---- "
    # test_link = 'http://localhost:8000/upload/'  # uncomment to test
    conn = Faraday.new url: 'http://e2j.opendevdata.ug/upload/' do |faraday|
    # conn = Faraday.new url: test_link do |faraday| # uncomment to test
      faraday.request :multipart
      faraday.adapter :net_http
    end
    logger.debug "-- connection object created..."
    payload = { upload_file: Faraday::UploadIO.new(tempfile_path,
                                                   'application/vnd.ms-excel'),
                chart_type: chart_type }
    logger.debug "--** Payload prepared... posting to connection"

    response = conn.post 'http://e2j.opendevdata.ug/upload/', payload
    # response = conn.post test_link, payload  # test

    if response.status == 200  #HTTP OK
      dataset = Dataset.find _id = dataset_id
      logger.debug "#{dataset.name} processed"
      json_response = response.body
      logger.debug "Updating dataset ***"
      dataset.data_extract = JSON.parse json_response
      dataset.save
    else
      puts "Failed"
    end
  end
end
