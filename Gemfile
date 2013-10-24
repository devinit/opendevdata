source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'bson_ext'
gem 'devise'
gem 'simple_form'
gem 'carrierwave'
gem "carrierwave-mongoid", "~> 0.6.0"
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongo'
gem 'mongoid-grid_fs', github: 'ahoward/mongoid-grid_fs'
gem 'mongoid_slug'
gem 'rb-readline', '~> 0.4.2' # added just for safety
# gem 'roo', '~> 1.2.3'
# gem 'spreadsheet'
gem 'iconv'
gem "ckeditor"
gem "sanitizer"
gem "mini_magick"
gem "smarter_csv"
gem 'rubyzip', '~> 0.9.9'
gem "resque", "~> 2.0.0.pre.1", github: "resque/resque"
gem "redis"
gem "faraday", github: 'lostisland/faraday'
gem 'faraday-http-cache'
gem 'resque-web', require: 'resque_web'
gem 'kaminari'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass', branch: '3'
gem 'jquery-turbolinks'
gem 'masonry-rails', '~> 0.2.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "mongoid-rspec"
  gem "launchy"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
end


group :development do
  gem 'pry-rails'
  gem 'pry-debugger'
end
