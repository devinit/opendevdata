CarrierWave.configure do |config|
  config.storage = :grip_fs
  config.grid_fs_access_url = "/datasets"
  config.grid_fs_database = Mongoid.database.name

  if Rails.env.production?
    config.grid_fs_database = ENV["MONGOID_DATABASE"] || Mongoid.database.name
    config.grid_fs_host = ENV["MONGOID_HOST"]
    config.grid_fs_port = ENV["MONGOID_PORT"]
    config.grid_fs_username = ENV["MONGOID_USERNAME"]
    config.grid_fs_password = ENV["MONGOID_PASSWORD"]
  end
end
