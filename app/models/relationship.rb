class Relationship < ApplicationRecord

    has_many :messages, class_name: 'Message', foreign_key: 'room_id'
    scope :not_rejected, -> {where("status != 'rejected'")}

    validate :ensure_unique_relationship,  on: :create
    validate :ensure_no_self_relationship,  on: :create

    def ensure_unique_relationship
        if (Relationship.where(user_id1: self.user_id2, user_id2: self.user_id1).not_rejected.exists? ||
            Relationship.where(user_id1: self.user_id1, user_id2: self.user_id2).not_rejected.exists?)
            errors.add(:relationships, "should be unique")
        end
    end

    def ensure_no_self_relationship
        if self.user_id2 == self.user_id1
            errors.add(:relationships, "cannot be with self")
        end
    end
end
