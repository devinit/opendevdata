class MessagesController < ApplicationController
  def index
    @messages = current_user.messages
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.create messages_params
    if @message.save
      render :json => { 'ok' => 'Successfully sent message'}
    else
      render json: { 'error' => "Cannot create Message. Try again"}
    end
  end

  def show
    @message = Message.find params[:id]
  end

  private
    def messages_params
      params.require(:message).permit(:content, :workspace_id, :user_id)
    end
end
