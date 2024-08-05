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
  audited

  enum role: {
    viewer: 0,
    agent: 1,
    admin: 2,
    super_admin: 3
  }

  # Callbacks to track user creation and updates
  after_create :track_user_creation
  around_create :measure_user_creation
  after_update :track_user_update
  around_update :measure_user_update

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def track_user_creation
    StatsD.increment("user.created")
    StatsD.gauge("user.count", User.count)
    Rails.logger.info "User created: #{email}"
  end

  def measure_user_creation
    StatsD.measure("user.creation_time") do
      yield
    end
  end

  def track_user_update
    StatsD.increment("user.updated")
    if saved_change_to_role?
      StatsD.increment("user.role_changed", tags: ["from:#{saved_change_to_role[0]}", "to:#{saved_change_to_role[1]}"])
    end
    Rails.logger.info "User updated: #{email}"
  end

  def measure_user_update
    StatsD.measure("user.update_time") do
      yield
    end
  end
end
