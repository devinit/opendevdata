class ExcelToJson
  @queue = :excel_to_json

  def self.perform(dataset_id, tempfile)
    puts "---- ***** ---- *** ---- "
    dataset = Dataset.find dataset_id
    puts "#{dataset.name} processing occurring..."
    uri = URI.parse('http://e2j.opendevdata.ug/upload')
    request = Net::HTTP.post_form(uri, {'excel' => tempfile.path })
    # TODO -> test if request.body is json response! (or provide error)
    dataset.update_attribute(:data_extract, request.body)
  end

end
