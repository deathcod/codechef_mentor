class UserController < ApplicationController

    IMAGES_PATH = File.join(Rails.root, "storage", "profile_pics")
    #/users/authenticate POST params: current_user
    def authenticate
        if params[:current_user].nil? || params[:current_user].blank?
            render json: {status: StatusCode::FAILURE, reason: "no user provided"} and return
        end
        render json: {status: StatusCode::SUCCESS, current_user: current_user.username} and return
    end

    def index
    end
    
    #/upload_profile_pic
    def upload_profile_pic
        File.open(File.join(IMAGES_PATH, "#{current_user.id}.jpg"), "wb") do |f|
            f.write params[:data].read
        end
    end

    #/dpwnload profile pic
    def download_profile_pic
        send_file(File.join(IMAGES_PATH, "#{current_user.id}.jpg"))
    end

    def auth_provider
        redirect_to "mentor://callback?code=#{params[:code]}&state=#{params[:state]}"
    end
end
