Opendataportal::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.

  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = { address: '127.0.0.1', port: 1025}

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log


  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  #config.action_mailer.delivery_method = :smtp
  # SMTP settings for gmail
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    :authentication => :plain,
    :address => "smtp.mailgun.org",
    :port => 587,
    :domain => "https://api.mailgun.net/v3/sandboxecc68e19013f41e99582d8f6e9312bcb.mailgun.org",
    :user_name => "postmaster@sandboxecc68e19013f41e99582d8f6e9312bcb.mailgun.org",
    :password => "e85e03b2220d48857c5c02f09d97c522"
  }
end
