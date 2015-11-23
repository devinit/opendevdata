# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :grid_fs
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    # asset_path("fallback/" + [version_name, "default.xls"].compact.join('_'))
    "default"
  end

  def file_version version = nil
    if version.nil?
      self.file
    elsif self.respond_to? version
      self.send(version).file
    else
      nil
    end
  end

  def image? file = nil
    file = self.file if file.nil?
    return nil if file.nil?

    file.content_type.include? 'image'
  end

  process :set_content_type

end
