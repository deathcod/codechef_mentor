module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # add validations later
    def connect
      self.current_user = User.find_by_username(cookies.signed[:current_user])
    end

  end
end
