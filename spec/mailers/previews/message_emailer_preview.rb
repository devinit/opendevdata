# Preview all emails at http://localhost:3000/rails/mailers/message_emailer
class MessageEmailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/message_emailer/new_email
  def new_email
    MessageEmailer.new_email
  end

end
