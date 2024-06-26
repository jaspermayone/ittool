class User < ApplicationRecord

  enum role: {
    viewer: 0,
    agent: 1,
    admin: 2,
    super_admin: 3
  }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
