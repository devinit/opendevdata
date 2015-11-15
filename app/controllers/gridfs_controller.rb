class GridfsController < ActionController::Metal

  def serve

    file_id = params[:fid]

    if params[:model] == "document"
      model = Document
    elsif params[:model] == "dataset"
      model = Dataset
    else
      model = nil
    end

    begin

      model_instance = model.find(file_id)

      if model_instance.nil? || model_instance.attachment.nil?
        raise Exception.new("Unable to find dataset document with id #{doc_id}")
      end

      filename = Pathname.new(env['PATH_INFO']).basename.to_s
      version = filename.include?('_') ? filename.split('_')[0] : nil

      gridfs_file = model_instance.attachment.file_version(version)
      gridfs_file = model_instance.attachment.file if gridfs_file.nil? || gridfs_file.length.nil?

      self.headers['Content-Length'] = gridfs_file.content_length.to_s
      self.headers['Expires'] = 1.year.from_now.httpdate
      self.response_body = gridfs_file.read
      self.content_type = gridfs_file.content_type
    rescue Exception => e
      self.status = :file_not_found
      self.content_type = 'text/plain'
      self.response_body = e.message
    end
  end

end
