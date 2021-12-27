class User < ApplicationRecord
  has_secure_password
  has_many :posts
  validates :email, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :nickname, presence: true, uniqueness: true, length: { minimum: 5 }
end
