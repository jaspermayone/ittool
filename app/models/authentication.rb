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

  def initialize(session, user)
    session[:current_authentication] = self
    @user_id = user.id
  end

  def destroy(session)
    session[:current_authentication] = nil
    @user_id = nil
  end

  def user
    User.find_by(id: @user_id)
  end

  def user=(user)
    @user_id = user.id
  end


end
