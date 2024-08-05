# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Authentication < ApplicationRecord
  audited

  # Track creation of an Authentication instance
  after_create :measure_creation

  # Track destruction of an Authentication instance
  after_destroy :measure_destruction

  def initialize(session, user)
    StatsD.increment("authentication.initialized")
    StatsD.measure("authentication.initialization_time") do
      session[:current_authentication] = self
      @user_id = user.id
    end
  end

  def destroy(session)
    StatsD.increment("authentication.destroyed")
    StatsD.measure("authentication.destruction_time") do
      session[:current_authentication] = nil
      @user_id = nil
    end
  end

  def user
    StatsD.increment("authentication.user_lookup")
    StatsD.measure("authentication.user_lookup_time") do
      User.find_by(id: @user_id)
    end
  end

  def user=(user)
    StatsD.increment("authentication.user_set")
    StatsD.measure("authentication.user_set_time") do
      @user_id = user.id
    end
  end

  private

  def measure_creation
    StatsD.measure("authentication.creation_time") do
      track_creation
    end
  end

  def track_creation
    StatsD.increment("authentication.created")
  end

  def measure_destruction
    StatsD.measure("authentication.destruction_time") do
      track_destruction
    end
  end

  def track_destruction
    StatsD.increment("authentication.deleted")
  end
end
