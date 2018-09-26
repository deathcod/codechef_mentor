class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room-#{params['room']}:messages"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    current_user.messages.create(body: data['message'], room_id: params['room'])
  end
end
