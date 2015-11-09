class ContactMailer < ActionMailer::Base

  default from: "epicallan.al@gmail.com"

  def sample_email(email)
    @email = email
    status = mail(to: @email.email, subject: 'Sample Email')
    puts "Mails post #{status}"
  end

end
