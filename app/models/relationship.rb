class Relationship < ApplicationRecord
     validates :user_id2, uniqueness: true
     validates :user_id1, uniqueness: true

     validate :ensure_unique_relationship, on: :create

     def ensure_unique_relationship
         !Relationship.where(user_id1: self.user_id2, user_id2: self.user_id1).exists?
     end
end
