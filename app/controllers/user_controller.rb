class UserController < ApplicationController
    protect_from_forgery with: :null_session
    
    #/mentors?usernames=AAA|BBB|CCC
    #/mentors?current_user=USERNAME
    def mentors
        if usernames
            data = {}
            usernames.each {|u| data[u.username] = u.mentors} 
            render json: data and return
        elsif current_user
            render json: current_user.mentors and return
        else
            render json: {status: "failure", reason: "no data provided"}
        end
    end

    #/students?usernames=AAA|BBB|CCC
    #/students?current_user=USERNAME
    def students
        if usernames
            data = {}
            usernames.each {|u| data[u.username] = u.students}
            render json: data and return
        elsif current_user
            render json: current_user.students and return
        else
            render json: {status: "failure", reason: "no data provided"}
        end
    end

    #/users?usernames=AAA|BBB|CCC
    #/users?current_user=USERNAME
    def users
        if usernames
            data = {}
            usernames.each {|u| data[u.username] = u.relationships} 
            render json: data and return
        elsif current_user
            render json: current_user.relationships and return
        else
            render json: {status: "failure", reason: "no data provided"}
        end
    end

    # users
    # params: mentor_name, current_user
    def create
        
        if params[:mentor_name].nil? || params[:current_user].nil?
            render json: {status: "failure", reason: "mentor_name or current_user is nil"} and return
        end

        create_relationship = Relationship.new(user_id1: mentor.id, user_id2: current_user.id, status: "pending")
        if create_relationship.valid?
            create_relationship.save
            render json: {status: "success"} and return
        else
            render json: {status: "failure", reason: create_relationship.errors.full_messages.first} and return
        end
    end

    # users
    # params: student_name, status, current_user
    def update
       if current_user.nil?
            render json: {status: "failure", reason: "current_user is nil"} and return
       elsif student.nil?
            render json: {status: "failure", reason: "student is nil"} and return
       elsif params[:status].nil?
            render json: {status: "failure", reason: "status is nil"} and return
       end

       relationship = Relationship.where(user_id1: current_user.id, user_id2: student.id).first
       if relationship.present?
           relationship.update_attributes!(status: params[:status])
           render json: {status: "success"} and return
       else
           render json: {status: "failure", reason: create_relationship.errors.full_messages.first} and return
       end
    end

    private

    def usernames
        return @usernames if @username
        if params[:usernames].nil?
            return nil
        else
            names = params[:usernames].split("|")
            @usernames ||= User.where(username: names)
        end
        return @usernames
    end

    def mentor
        @mentor ||= User.find_or_create_by(username: params[:mentor_name])
    end

    def student
        @student ||= User.find_or_create_by(username: params[:student_name])
    end

    def current_user
        return @current_user if @current_user
        if params[:current_user]
            @current_user = User.find_or_create_by(username: params[:current_user])
        elsif params[:id]
            @current_user = User.find_or_create_by(username: params[:id])
        end
        return @current_user
    end
end
