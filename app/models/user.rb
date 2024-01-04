class User < ApplicationRecord
  has_secure_password
  has_many :articles
  validates :email, presence: true, uniqueness: true
  validates :account_id, presence: true, uniqueness: true
end
