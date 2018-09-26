class Message < ApplicationRecord
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_message

  def to_hash
    {
      message: self.body, 
      sender_name: self.user.username,
      time: self.created_at.to_datetime.new_offset('+530').strftime("%H:%M")
    }
  end

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end

end
