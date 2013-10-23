# encoding: UTF-8
require 'faraday'

class ExcelToJson
  @queue = :excel_to_json

  def self.perform(dataset_id, tempfile, chart_type)
    puts "---- ***** ---- *** ---- "
    conn = Faraday.new url: 'http://e2j.opendevdata.ug/upload/' do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end

    payload = { upload_file: Faraday::UploadIO.new(tempfile.path,
                                                   'application/vnd.ms-excel'),
                chart_type: chart_type }

    response = conn.post 'http://e2j.opendevdata.ug/upload/', payload
    # dataset = Dataset.find dataset_id
    # dataset.update_attribute(:data_extract, request.body)
    # puts "#{dataset.name} processed..."
    response.body  # returns a response in form of json

  end
end
