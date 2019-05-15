# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'paranoia'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'scenic'
gem 'sidekiq', '~> 5.0'
gem 'sidekiq-scheduler'
gem 'webpacker'
gem 'omniauth_openid_connect'
gem 'simple_command', '~> 0.0.9'
gem 'dotenv-rails', '~> 2.7', require: 'dotenv/rails-now'

# Manage JWT tokens
gem 'json-jwt', '~> 1.9'

# Uploads
gem 'carrierwave'
gem 'fog-aws'

# Other
gem 'cocoon'
gem 'devise'
gem 'devise_invitable'
gem 'friendly_id'
gem 'kaminari'
gem 'pundit'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'responders'
gem 'rubyXL'

# Rollbar
gem 'oj'
gem 'rollbar'

# Views
gem 'bootstrap', '4.0.0.beta2.1'
gem 'bower-rails'
gem 'entypo-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'foreman'
  gem 'rubocop'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
end

group :test do
  gem 'codacy-coverage', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rspec-collection_matchers'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'timecop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'dry-transaction'
gem "annotate", "~> 2.7"