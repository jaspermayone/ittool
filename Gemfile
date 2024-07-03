source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(File.dirname(__FILE__), ".ruby-version")).strip

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

gem "pg" # database
gem "pg_search" # full-text search

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "annotate" # comment models with database schema

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "listen", "~> 3.8"
  gem "web-console"

  gem "letter_opener"
  gem "letter_opener_web", "~> 3.0"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
  # gem "memory_profiler"
  # gem "stackprof"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  #

  # Ruby language server
  gem "solargraph"
  gem "solargraph-rails", "~> 1.1.0"

  gem "htmlbeautifier", require: false # for https://marketplace.visualstudio.com/items?itemName=tomclose.format-erb

  gem "bullet"
  gem "debugbar"
  gem "rails_hotreload"
  gem "sorbet"

  gem "after_commit_everywhere"
  gem "isolator"

  # Speaking of profiling, here are some must-have tools
  gem "derailed_benchmarks"
  gem "rack-mini-profiler"
  gem "stackprof"

  gem "brakeman", require: false
  gem "bundler-audit", require: false

  gem "attractor"
  gem "coverband"
  gem "danger", require: false
  gem "next_rails"
  gem "pre-commit", require: false

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.4'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "bulma-rails"
gem "font-awesome-sass", "~> 6.5.2"

gem "audits1984"
gem "console1984"

gem "mission_control-jobs"
gem "solid_queue"

gem 'aasm'
gem 'csv'
gem 'postmark-rails'
gem "statsd-instrument", "~> 3.8" # For reporting to jasper's Grafana
gem 'google-apis-admin_directory_v1', '~> 0.57.0'
