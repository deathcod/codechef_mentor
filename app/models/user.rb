class User < ApplicationRecord
    has_many :mentor_relation, class_name: 'Relationship', foreign_key: 'user_id2'
    has_many :student_relation, class_name: 'Relationship', foreign_key: 'user_id1'
    has_many :messages, dependent: :destroy
    has_one_attached :avatar

    def mentors
	return @mentors_data if @mentors_data
        @mentors_data ||= []
        self.mentor_relation.not_rejected.each do |mr|
           @mentors_data << {
              username: User.find(mr.user_id1).username,
              status: mr.status,
              relationship: "mentor",
              room_id: mr.id
           }
        end
        return @mentors_data
    end

    def students
        return @students_data if @students_data
        @students_data ||= []
        self.student_relation.not_rejected.each do |sr|
            @students_data << {
                username: User.find(sr.user_id2).username,
                status: sr.status,
                relationship: "student",
                room_id: sr.id
            }
        end
        return @students_data
    end

    def relationships
        return @relationships if @relationships
        @relationships ||= []
        self.mentors.each  {|m| @relationships << m }
        self.students.each {|s| @relationships << s }
        return @relationships
    end
end

