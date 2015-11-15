class EmailerController < ApplicationController
  require 'mailgun'
  require 'rest_client'

  def send_mail
    @emailer = Emailer.new
    @emailer.email = params[:email]
    @emailer.content = params[:content]
    if @emailer.save
      MessageEmailer.new_email(@emailer).deliver
      render json: { 'result' => true}
    else
      render json: { 'result' => false}
    end
  end

  private
    def send_simple_message
      #hack for testing purposes
      RestClient::Request.execute(
        :url => "https://api:key-853947d58dbbd63d65a2c2a6161fa04c"\
                "@api.mailgun.net/v3/sandboxecc68e19013f41e99582d8f6e9312bcb.mailgun.org/messages",
        :method => :post,
        :payload => {
          :from => 'Mailgun Sandbox <postmaster@sandbox30000.mailgun.org>',
          :sender => 'Mailgun Sandbox <postmaster@sandbox30000.mailgun.org>',
          :to => 'epicallan.al@gmail.com',
          :subject => "Hello XYZ",
          :text => @emailer.content,
          :multipart => true
        },
        :headers => {
          :"h:X-My-Header" => "www/mailgun-email-send"
        },
        :verify_ssl => false
      )
    end

    def emailMessage(mg_client)
      message_params = {:from    => @emailer.email,
                        :to      => 'epicallan.al@gmail.com',
                        :subject => 'Message from opendevdata.ug',
                        :text    => @emailer.content}
      mg_client.send_message ENV['MG_DOMAIN'], message_params
    end
end
