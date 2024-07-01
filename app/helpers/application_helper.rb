module ApplicationHelper

def current_page?(path)
  request.path == path
end

def relative_timestamp(time, options = {})
  ontent_tag :span, "#{options[:prefix]}#{time_ago_in_words time} ago#{options[:suffix]}", options.merge(title: time)
end

def time_until_due(due_date)
  if due_date < Time.current
    "#{distance_of_time_in_words(due_date, Time.current)} overdue"
  else
    "#{distance_of_time_in_words(Time.current, due_date)}"
  end
end

def help_message
  content_tag :span, "Email #{help_email} for support.".html_safe
end

def help_email
  mail_to "me@jaspermayone.com"
end

def commit_name
  @short_hash ||= commit_hash[0...7]
  @commit_name ||= begin
    if commit_dirty?
      "#{@short_hash}-dirty"
    else
      @short_hash
    end
  end
end

def commit_dirty?
  ::Util.commit_dirty?
end

def commit_hash
  ::Util.commit_hash
end

def commit_time
  @commit_time ||= begin
    heroku_time = ENV["HEROKU_RELEASE_CREATED_AT"]
    git_time = `git log -1 --format=%at`&.chomp

    return nil if heroku_time.blank? && git_time.blank?

    heroku_time.blank? ? git_time.to_i : Time.parse(heroku_time)
  end

  @commit_time
end

def commit_duration
  @commit_duration ||= begin
    return nil if commit_time.nil?

    distance_of_time_in_words Time.at(commit_time), Time.now
  end
end

module_function :commit_hash, :commit_time

def app_version
  @app_version ||= begin
    if Rails.env.development?
      "DEVELOPMENT"
    else
      env = Rails.env.upcase
      time = Time.now.utc.strftime("%Y-%m-%d %H-%M UTC")
      "#{env} @ #{time} (#{commit_name})"
    end
  end
end

def rails_version
  Rails::VERSION::STRING
end

def ruby_version
  RUBY_VERSION
end

def current_year
  ::Util.current_year
end

end
