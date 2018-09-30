module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # add validations later
    def connect
      authenticate_request!
      self.current_user = User.find_by_username(cookies.signed[:current_user])
    end

    protected:
    def authenticate_request!
      Rails.logger.info("ApplicationCable::authenticate_request!::success#{request.params[:auth_code]}")
    end
  end
end
