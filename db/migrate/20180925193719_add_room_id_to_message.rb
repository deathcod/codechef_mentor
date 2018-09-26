class AddRoomIdToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :room_id, :integer
  end
end
