class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "room-#{message.room_id}:messages", message.to_hash
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message}
  end
end
