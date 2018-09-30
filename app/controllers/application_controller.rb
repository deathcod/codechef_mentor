class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  module StatusCode
    SUCCESS = "success".freeze
    FAILURE = "failure".freeze
  end
  
  attr_reader :current_user

  protected

  def authenticate_request!
    Rails.logger.info("ApplicationController::authenticate_request!::auth_code::#{request.headers["Auth-Code"]}")
    if request.headers["Auth-Code"].nil?
      render json: { status: StatusCode::FAILURE, reason: 'Auth code not found' }, status: :unauthorized and return
    elsif cookies.signed[:current_user].nil?
      render json: { status: StatusCode::FAILURE, reason: 'current user not found' }, status: :unauthorized and return
    end

    @current_user = User.find_by_username(cookies.signed[:current_user])
    Rails.logger.info("ApplicationController::authenticate_request!::success#{current_user.username}")
  end
end
