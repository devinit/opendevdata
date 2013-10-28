# encoding: UTF-8
require 'faraday'

class ExcelToJson
  @queue = :excel_to_json

  def self.perform dataset_id, tempfile_path, chart_type, file_name
    puts "---- ***** ---- *** ---- "
    conn = Faraday.new url: 'http://e2j.opendevdata.ug/upload/' do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end
    puts "-- connection object created..."
    payload = { upload_file: Faraday::UploadIO.new(tempfile_path,
                                                   'application/vnd.ms-excel'),
                chart_type: chart_type }
    puts "--** Payload prepared... posting to connection"

    response = conn.post 'http://e2j.opendevdata.ug/upload/', payload

    if response.status == 200  #HTTP OK
      dataset = Dataset.find _id = dataset_id
      puts "#{dataset.name} processed"
      json_response = response.body
      puts "Updating dataset ***"
      dataset.data_extract = JSON.parse json_response  # parse json response
      dataset.save
    else
      puts "Failed"
    end
  end
end
