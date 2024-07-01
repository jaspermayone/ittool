# == Schema Information
#
# Table name: borrowers
#
#  id              :integer          not null, primary key
#  email           :string
#  first_name      :string
#  flagged         :boolean
#  graduation_year :integer
#  last_name       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class StudentEmailValidator < ActiveModel::Validator
  def validate(record)
    # Increment a counter for validation attempts
    StatsD.increment("email_validation_attempts")

    if record.email.blank?
      # Log and increment counter for blank email errors
      StatsD.increment("email_validation_blank_errors")
      record.errors.add(:email, "can't be blank")
    elsif record.email =~ /^[a-zA-Z][a-zA-Z]+[0-9]{4}@huusd\.org$/
      # Log successful validation
      StatsD.increment("email_validation_success")
    else
      # Log and increment counter for format errors
      StatsD.increment("email_validation_format_errors")
      record.errors.add(:email, 'must be in the format: first initial, last name, and 4-digit graduation year (e.g., jdoe2024@huusd.org)')
    end
  end
end

class Borrower < ApplicationRecord
  has_many :loans
  validates :email, presence: true, student_email: true

  before_create :parse_email
  after_create :track_creation
  after_update :track_update
  after_destroy :track_destruction

  def full_name
    StatsD.increment("borrower.full_name_accessed")
    "#{first_name} #{last_name}"
  end

  def name
    StatsD.increment("borrower.name_accessed")
    "#{full_name}"
  end

  def flame
    StatsD.increment("borrower.flame_accessed")
    if flagged
      "🚩 #{name}"
    else
      name
    end
  end

  def grade_level
    StatsD.increment("borrower.grade_level_calculated")
    current_month = Time.now.month
    current_year = Time.now.year
    graduation_year = self.graduation_year

    if current_month <= 5
      academic_year = current_year - 1
    else
      academic_year = current_year
    end

    tmp_grade_level = academic_year - graduation_year
    case tmp_grade_level.abs
    when 1
      grade_level = 12
    when 2
      grade_level = 11
    when 3
      grade_level = 10
    when 4
      grade_level = 9
    when 5
      grade_level = 8
    else
      grade_level = 0 # staff (should not error)
    end

    grade_level
  end

  private

  def parse_email
    StatsD.increment("borrower.parse_email_started")
    # Split the email address before the "@" symbol
    local_part = email.split('@').first

    # Split the local part into the name part and the graduation year
    name_part, graduation_year = local_part.scan(/([a-zA-Z]+)(\d{4})/).flatten

    # Assign the appropriate attributes
    self.first_name = name_part[0].capitalize
    self.last_name = name_part[1..-1].capitalize
    self.graduation_year = graduation_year

    StatsD.increment("borrower.parse_email_completed")
  end

  def track_creation
    StatsD.increment("borrower.created")
  end

  def track_update
    StatsD.increment("borrower.updated")
  end

  def track_destruction
    StatsD.increment("borrower.deleted")
  end
end
