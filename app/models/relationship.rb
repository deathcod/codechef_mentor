class Relationship < ApplicationRecord

    has_many :messages, class_name: 'Message', foreign_key: 'room_id'

    validate :ensure_unique_relationship, on: :create

    def ensure_unique_relationship
        if (Relationship.where(user_id1: self.user_id2, user_id2: self.user_id1).exists? ||
            Relationship.where(user_id1: self.user_id1, user_id2: self.user_id2).exists?)
            errors.add(:relationships, "should be unique")
        end
    end
end
