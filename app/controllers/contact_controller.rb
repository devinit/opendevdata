class ContactController < ApplicationController
  def send_mail
    #gets email payload
    #saves payload as
    @emailer = Emailer.new

    @emailer.email = params[:email]
    @emailer.content = params[:content]
    if @emailer.save
      #sends email
      ContactMailer.sample_email(@emailer)
      render json: { 'result' => true}
    else
      render json: { 'result' => false}
    end
  end
end
