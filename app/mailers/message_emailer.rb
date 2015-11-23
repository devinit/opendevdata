class MessageEmailer < ActionMailer::Base
  default from: 'messages@opendevdata.ug'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_emailer.new_email.subject
  #
  def new_email(email)
    @emailer = email
    mail(:to => 'info@drt-ug.org,bsabiti@drt-ug.org,jjnsubuga@drt-ug', :subject =>"Message from opendevdata",reply_to: @emailer.email)
  end
end
