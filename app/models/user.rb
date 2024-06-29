# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  f_name          :string
#  l_name          :string
#  password_digest :string
#  role            :integer          default("viewer"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  enum role: {
    viewer: 0,
    agent: 1,
    admin: 2,
    super_admin: 3
  }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
