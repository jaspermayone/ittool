class StudentEmailValidator < ActiveModel::Validator
  def validate(record)
    unless record.email =~ /^[a-zA-Z][a-zA-Z]+[0-9]{4}@huusd\.org$/
      record.errors.add(:email, 'must be in the format: first initial, last name, and 4-digit graduation year (e.g., jdoe2024@huusd.org)')
    end
  end
end

class Borrower < ApplicationRecord
  has_many :loans
  validates :email, presence: true, student_email: true

  before_create :parse_email

  def full_name
    "#{first_name} #{last_name}"
  end

  def grade_level
    current_month = Time.now.month
  current_year = Time.now.year
  graduation_year = self.graduation_year

    if current_month <= 5
      academic_year = current_year - 1
    else
      academic_year = current_year
    end

    tmp_grade_level = academic_year - graduation_year
    # if tmp_grade_level.abs is = 1, then the student is in 12th grade
    # if tmp_grade_level.abs is = 2, then the student is in 11th grade
    # etc

    if tmp_grade_level.abs == 1
      grade_level = 12
    elsif tmp_grade_level.abs == 2
      grade_level = 11
    elsif tmp_grade_level.abs == 3
      grade_level = 10
    elsif tmp_grade_level.abs == 4
      grade_level = 9
    elsif tmp_grade_level.abs == 5
      grade_level = 8
    # add grade 7
    else
      grade_level = 0 # staff (should not error)
    end

    grade_level
  end


  private

  def parse_email

    # email comes in as "first initial, last name, and 4-digit graduation year @huusd.org", split out the parts
    # and assign them to the appropriate attributes

    # Split the email address before the "@" symbol
    local_part = email.split('@').first

    # Split the local part into the name part and the graduation year
    name_part, graduation_year = local_part.scan(/([a-zA-Z]+)(\d{4})/).flatten

    # Assign the appropriate attributes
  self.first_name = name_part[0].capitalize
  self.last_name = name_part[1..-1].capitalize
  self.graduation_year = graduation_year
  end
end
