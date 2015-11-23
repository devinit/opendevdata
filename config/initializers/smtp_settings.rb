ActionMailer::Base.smtp_settings = {
    :user_name => 'katotodeveloper',
    :password => 'katoto2015',
    :domain => 'opendevdata.ug',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
