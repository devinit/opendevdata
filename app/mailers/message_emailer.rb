class MessageEmailer < ActionMailer::Base
  default from: "opendevdata@ug.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_emailer.new_email.subject
  #
  def new_email(email)
    @emailer = email
    mail to: 'epicallan.al@gmail.com', subject: "Success! You did it."
  end
end
