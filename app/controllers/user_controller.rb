class UserController < ApplicationController
    protect_from_forgery with: :null_session
    
    #/mentors?usernames=AAA|BBB|CCC&current_user=USERNAME
    #/mentors?current_user=USERNAME
    def mentors
        if usernames
            data = {}
            User.where(username: usernames).each {|u| data[u.username] = u.mentors} 
            render json: data and return
        else
            render json: current_user.mentors and return
        end
    end

    #/students?usernames=AAA|BBB|CCC&current_user=USERNAME
    #/students?current_user=USERNAME
    def students
        if usernames
            data = {}
            User.where(username: usernames).each {|u| data[u.username] = u.students}
            render json: data and return
        else
            render json: current_user.students and return
        end
    end

    #/users?usernames=AAA|BBB|CCC&current_user=USERNAME
    def users
        if usernames
            data = {}
            User.where(username: usernames).each {|u| data[u.username] = u.relationships} 
            render json: data and return
        else
            render json: current_user.relationships and return
        end
    end

    # users
    # params: mentor_name, current_user
    def create
        if params[:mentor_name].nil? || params[:current_name].nil?
            render json: {status: "failure", reason: "mentor_name or current_user is nil"} and return
        end

        mentor = User.find_or_create_by(username: params[:mentor_name])
        @current_user = User.find_or_create_by(username: params[:current_name])
        create_relationship = Relationship.create(user_id1: mentor.id, user_id2: current_user.id, status: "pending")
	if create_relationship.valid?
            render json: {status: "success"} and return
        else
            render json: {status: "failure", reason: create_relationship.errors.full_messages.first} and return
        end
    end

    # users
    # params: student_name, status, current_user
    def update
       student = User.where(username: params[:student_name]).first
       relationship = Relationship.find(user_id1: current_user.id, user_id2: student.id)
       relationship.update_attributes!(status: params[:status])
       if relationship.valid?
           render json: {status: "success"} and return
       else
           render json: {status: "failure", reason: create_relationship.errors.full_messages.first} and return
       end
    end

    private

    def usernames
        @usernames ||= params[:usernames] && params[:usernames].split("|")
    end

    def current_user
        @current_user ||= User.where(username: params[:current_user]).first
    end
end
