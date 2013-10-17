class ExcelToJson
  @queue = :excel_to_json

  def self.perform(dataset_id, tempfile)
    puts "---- ***** ---- *** ---- "
    dataset = Dataset.find dataset_id
    puts "#{dataset.name} processing occurring..."
    # uri = URI.parse('http://excel2json.miclovich.me/')
    # request = Net::HTTP.post_form(uri, {'excel' => tempfile.path })
    # dataset.update_attribute(:data_extract, request.body)
  end

end
