class UserController < ApplicationController

    #/users/authenticate POST params: current_user
    def authenticate
        if params[:current_user].nil? || params[:current_user].blank?
            render json: {status: StatusCode::FAILURE, reason: "no user provided"} and return
        end
        render json: {status: StatusCode::SUCCESS, current_user: current_user.username, profile_pic_url: profile_pic_url} and return
    end

    def index
    end
    
    #/upload_profile_pic PUT avatar
    def upload_profile_pic
        if params[:avatar].nil? || params[:avatar].blank?
            render json: {status: StatusCode::FAILURE, reason: "no profile pic provided"} and return
        end
        current_user.avatar.attach(params[:avatar])
        current_user.save
        if current_user.valid? 
            render json: {status: StatusCode::SUCCESS, profile_pic_url: profile_pic_url} and return
        end
    end

    private

    def profile_pic_url
        if current_user.avatar.attached?
            return url_for(current_user.avatar)
        else
            return ""
        end
    end
end
