class UserController < ApplicationController
    before_action :authenticate_request!, :except => [:authenticate]

    IMAGES_PATH = File.join(Rails.root, "storage", "profile_pics")
    PENDING_AUTH_CODE = "pending_auth_code".freeze
    APPROVED_AUTH_CODE = "approved_auth_code".freeze

    #/users/authenticate POST params: current_user
    def authenticate
        if params[:current_user].nil? || params[:current_user].blank?
            render json: {status: StatusCode::FAILURE, reason: "no user provided"} and return
        end
        
        if params[:auth_code].nil?
            render json: {status: StatusCode::FAILURE, reason: "Auth Code not provided"} and return
        end

        REDIS_POOL.with do |conn| 
            if conn.sismember(PENDING_AUTH_CODE, params[:auth_code]) == 1
                conn.srem(PENDING_AUTH_CODE, params[:auth_code])
                conn.hset(APPROVED_AUTH_CODE, params[:current_user], params[:auth_code])
            else
                render status: :unauthorized and return
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
