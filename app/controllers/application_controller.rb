class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  module StatusCode
    SUCCESS = "success".freeze
    FAILURE = "failure".freeze
  end

  PENDING_AUTH_CODE = "pending_auth_code".freeze
  APPROVED_AUTH_CODE = "approved_auth_code".freeze
  
  attr_reader :current_user

  protected

  def authenticate_request!
    
    user_name = cookies.signed[:current_user]
    auth_code = request.headers["Auth-Code"]

    Rails.logger.info("ApplicationController::authenticate_request!::auth_code::#{user_name}")
    Rails.logger.info("ApplicationController::authenticate_request!::cookies::#{auth_code}")

    if auth_code.nil?
      render json: { status: StatusCode::FAILURE, reason: 'Auth code not found' }, status: :unauthorized and return
    elsif user_name.nil?
      render json: { status: StatusCode::FAILURE, reason: 'current user not found' }, status: :unauthorized and return
    end

    if REDIS_POOL.with {|conn| conn.hget(APPROVED_AUTH_CODE, user_name)} == auth_code
      @current_user = User.find_by_username(user_name)
      Rails.logger.info("ApplicationController::authenticate_request!::success#{current_user.username}")
    else
      Rails.logger.info("ApplicationController::authenticate_request!::failure#{current_user.username}")
      render json: { status: StatusCode::FAILURE, reason: 'Invalid Auth code or User' }, status: :unauthorized and return
    end
  end
end
