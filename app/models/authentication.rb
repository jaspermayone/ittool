# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Authentication < ApplicationRecord
  # frozen_string_literal: true

  # Track creation of an Authentication instance
  after_create :track_creation

  # Track destruction of an Authentication instance
  after_destroy :track_destruction

  def initialize(session, user)
    StatsD.increment("authentication.initialized")
    session[:current_authentication] = self
    @user_id = user.id
  end

  def destroy(session)
    StatsD.increment("authentication.destroyed")
    session[:current_authentication] = nil
    @user_id = nil
  end

  def user
    StatsD.increment("authentication.user_lookup")
    User.find_by(id: @user_id)
  end

  def user=(user)
    StatsD.increment("authentication.user_set")
    @user_id = user.id
  end

  private

  def track_creation
    StatsD.increment("authentication.created")
  end

  def track_destruction
    StatsD.increment("authentication.deleted")
  end
end
