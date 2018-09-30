module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    APPROVED_AUTH_CODE = "approved_auth_code".freeze

    # add validations later
    def connect
      if authenticated_request?
        self.current_user = User.find_by_username(cookies.signed[:current_user])
      else
	reject_unauthorized_connection
      end
    end

    def authenticated_request?
      auth_code = request.params[:auth_code]
      user_name = cookies.signed[:current_user]
      if REDIS_POOL.with {|conn| conn.hget(APPROVED_AUTH_CODE, user_name)} == auth_code
        return true
      else
        return false
      end
    end
  end
end
