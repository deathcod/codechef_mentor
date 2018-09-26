class ChatController < ApplicationController

  def index
    @messages = Message.order(created_at: :asc)
  end

  # /chats/:id
  def show
    @messages = Message.where(room_id: params[:id]).order(created_at: :asc).map(&:to_hash)
    render json @messages and return
  end

end
