class UserController < ApplicationController
    before_action :authenticate_request!, :except => [:authenticate, :auth_provider]

    IMAGES_PATH = File.join(Rails.root, "storage", "profile_pics")

    #/users/authenticate POST params: current_user
    def authenticate
        if params[:current_user].nil? || params[:current_user].blank?
            render json: {status: StatusCode::FAILURE, reason: "no user provided"} and return
        end
        
        auth_code = request.headers["Auth-Code"]
	    Rails.logger.info("UserController::authenticate::auth_code::#{auth_code}")
        if auth_code.nil?
            render json: {status: StatusCode::FAILURE, reason: "Auth Code not provided"}, status: :unauthorized and return
        end

        REDIS_POOL.with do |conn| 
            if conn.sismember(PENDING_AUTH_CODE, auth_code) == true
                conn.srem(PENDING_AUTH_CODE, auth_code)
                conn.hset(APPROVED_AUTH_CODE, params[:current_user], auth_code)
            else
                render json: {status: StatusCode::FAILURE, reason: "Auth Code not valid"}, status: :unauthorized and return
            end
        end

        Rails.logger.info("ApplicationController::authenticate::success#{params[:current_user]}")
        cookies.signed[:current_user] = User.find_or_create_by(username: params[:current_user])
        render json: {status: StatusCode::SUCCESS, current_user: params[:current_user]} and return
    end

    def index
    end
    
    #/upload_profile_pic
    def upload_profile_pic
        File.open(File.join(IMAGES_PATH, "#{current_user.id}.jpg"), "wb") do |f|
            f.write params[:data].read
        end
    end

    #/download profile pic
    def download_profile_pic
        send_file(File.join(IMAGES_PATH, "#{current_user.id}.jpg"))
    end

    def auth_provider
        REDIS_POOL.with {|conn| conn.sadd(PENDING_AUTH_CODE, params[:code])}
        redirect_to "mentor://callback?code=#{params[:code]}&state=#{params[:state]}"
    end
end
