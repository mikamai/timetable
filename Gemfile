# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'paranoia', '~> 2.4.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'scenic', '~> 1.4.1'
gem 'sidekiq', '~> 5.0'
gem 'sidekiq-scheduler'
gem 'webpacker', '~> 3.3.1'
gem 'omniauth_openid_connect', '~> 0.2.4'
gem 'simple_command', '~> 0.0.9'
gem 'dotenv-rails', '~> 2.7', require: 'dotenv/rails-now'

# Manage JWT tokens
gem 'json-jwt', '~> 1.9'

# Uploads
gem 'carrierwave', '~> 1.2.2'
gem 'fog-aws', '~> 2.0.0'

# Other
gem 'cocoon', '~> 1.2.11'
gem 'devise', '~> 4.7.1'
gem 'devise_invitable', '~> 1.7.2'
gem 'friendly_id', '~> 5.2.3'
gem 'kaminari', '~> 1.1.1'
gem 'pundit', '~> 1.1.0'
gem 'ransack', '~> 1.8.4'
gem 'responders', '~> 2.4.0'
gem 'rubyXL', '~> 3.3.27'

# Rollbar
gem 'oj', '~> 3.3.9'
gem 'rollbar', '~> 2.15.5'

# Views
gem 'bootstrap', '>= 4.3.1'
gem 'bower-rails', '~> 0.11.0'
gem 'entypo-rails', '~> 3.0.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3.1'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails', '~> 3.1.3'
gem 'uglifier', '>= 1.3.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.1.0', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'pry', '~> 0.11.1'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'selenium-webdriver', '~> 3.8.0'
end

group :development do
  gem 'foreman', '~> 0.85.0'
  gem 'rubocop', '~> 0.51.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener', '~> 1.7.0'
end

group :test do
  gem 'codacy-coverage', '~> 1.1.8', require: false
  gem 'database_cleaner', '~> 1.6.1'
  gem 'rails-controller-testing', '~> 1.0.2'
  gem 'rspec-collection_matchers', '~> 1.1.3'
  gem 'rspec_junit_formatter', '~> 0.3.0'
  gem 'shoulda-matchers', '~> 3.1.2'
  gem 'timecop', '~> 0.9.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'dry-transaction', '~> 0.13.0'
gem 'annotate', '~> 2.7'

