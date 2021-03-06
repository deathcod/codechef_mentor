class RelationshipController < ApplicationController
  before_action :authenticate_request!
  #/mentors?usernames=AAA|BBB|CCC
  #/mentors?current_user=USERNAME  [TODO: deprecate]
  def mentors
      if usernames
          data = {}
          usernames.each {|u| data[u.username] = u.mentors} 
          render json: data and return
      elsif current_user
          render json: {status: "success", response: current_user.mentors} and return
      else
          render json: {status: StatusCode::FAILURE, reason: "no data provided"}
      end
  end

  #/students?usernames=AAA|BBB|CCC
  #/students?current_user=USERNAME  [TODO: deprecate]
  def students
      if usernames
          data = {}
          usernames.each {|u| data[u.username] = u.students}
          render json: data and return
      elsif current_user
          render json: {status: "success", response: current_user.students} and return
      else
          render json: {status: StatusCode::FAILURE, reason: "no data provided"}
      end
  end

  #/users?usernames=AAA|BBB|CCC
  #/users?current_user=USERNAME  [TODO: deprecate]
  def users
      if usernames
          data = {}
          usernames.each {|u| data[u.username] = u.relationships} 
          render json: data and return
      elsif current_user
          render json: {status: "success", response: current_user.relationships} and return
      else
          render json: {status: StatusCode::FAILURE, reason: "no data provided"}
      end
  end

  # users
  # params: mentor_name, current_user
  def create
      if params[:mentor_name].nil?
          render json: {status: StatusCode::FAILURE, reason: "mentor_name is nil"} and return
      end

      create_relationship = Relationship.new(user_id1: mentor.id, user_id2: current_user.id, status: "pending")
      if create_relationship.valid?
          create_relationship.save
          render json: {status: StatusCode::SUCCESS} and return
      else
          render json: {status: StatusCode::FAILURE, reason: create_relationship.errors.full_messages.first} and return
      end
  end

  # users
  # params: student_name, status, current_user
  def update
     if current_user.nil?
          render json: {status: StatusCode::FAILURE, reason: "current_user is nil"} and return
     elsif student.nil?
          render json: {status: StatusCode::FAILURE, reason: "student is nil"} and return
     elsif params[:status].nil?
          render json: {status: StatusCode::FAILURE, reason: "status is nil"} and return
     end

     relationship = Relationship.not_rejected.where(user_id1: current_user.id, user_id2: student.id).first
     if relationship.present?
         relationship.update_attributes!(status: params[:status])
         render json: {status: StatusCode::SUCCESS} and return
     else
         render json: {status: StatusCode::FAILURE, reason: create_relationship.errors.full_messages.first} and return
     end
  end

  #/leaderboard
  #/leaderboard?num=10 #testing
  def leaderboard
    num = 3
    num = params[:num] if params[:num]
    data = User.limit(num).all.map do |u|
      {
        current_user: u.username,
        score: u.student_relation.where(status: "approved").reduce(0) {|a, b| a + b.messages.where(user_id: b.user_id1).count + 1}
      }
    end 
    
    render json: data.sort_by{|a| -a[:score]} and return
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
end
