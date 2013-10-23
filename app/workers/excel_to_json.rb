# encoding: UTF-8
require 'faraday'

class ExcelToJson
  @queue = :excel_to_json

  def self.perform(dataset_id, tempfile, chart_type)
    puts "---- ***** ---- *** ---- "
    # dataset = Dataset.find dataset_id
    # puts "#{dataset.name} processing occurring..."
    # uri = URI.parse('http://e2j.opendevdata.ug/upload')
    # request = Net::HTTP.post_form(uri, {'excel' => tempfile.path })
    # TODO -> test if request.body is json response! (or provide error)
    # dataset.update_attribute(:data_extract, request.body)

    conn = Faraday.new url: 'http://e2j.opendevdata.ug/upload/' do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end

    payload = { upload_file: Faraday::UploadIO.new(tempfile.path,
                                                   'application/vnd.ms-excel'),
                chart_type: chart_type }

    response = conn.post 'http://e2j.opendevdata.ug/upload/', payload
    response.body  # returns a response in form of json
  end
end
