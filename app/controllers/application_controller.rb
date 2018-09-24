class ApplicationController < ActionController::Base
  before_action :set_cors_headers if Rails.env.development?

  module StatusCode
    SUCCESS = "success".freeze
    FAILURE = "failure".freeze
  end
  
  protected

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8887'
    response.headers['Access-Control-Allow-Methods'] = 'GET,PUT,POST,DELETE'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization,X-Requested-With,content-type'
  end

  def current_user
    if cookies.signed[:current_user]
      @current_user ||= User.find_by_username(cookies.signed[:current_user])
    elsif params[:current_user]
      @current_user ||= User.find_or_create_by(username: params[:current_user])
      cookies.signed[:current_user] ||= params[:current_user]
    elsif params[:id]
      @current_user ||= User.find_or_create_by(username: params[:id])
      cookies.signed[:current_user] ||= params[:current_user]
    end
    return @current_user
  end
end