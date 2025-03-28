class User < ApplicationRecord
    validates :user_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
