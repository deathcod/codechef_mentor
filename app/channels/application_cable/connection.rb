module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # add validations later
    def connect
      self.current_user = User.last
    end

  end
end
