source 'https://rubygems.org'
ruby '2.4.3'

gem 'rails', '~> 5.0.0'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# run cron like tasks
gem 'clockwork'

gem 'airbrake', '~> 5.0'

group :production do
  gem 'pg' # use postgres in production
  gem 'rails_12factor'
end

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'dalli'
gem 'activerecord-session_store'
gem 'faraday'
gem 'oauth2'
gem 'rack-cache'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~>5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# simple token auth. the simplest
gem 'has_secure_token'

# for ical fun
gem 'icalendar'
gem 'tzinfo'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'dotenv-rails', require: 'dotenv/rails-now'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Check version. byebug works with version 2.*, but not with 1.*
  # debugger works with 1.*, but not with 2.*
  if RUBY_VERSION.start_with?('2')
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platform: :mri
  else
    # Call 'debugger' anywhere in the code to stop execution and get a debugger console
    gem 'debugger'
  end

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

gem 'sucker_punch', '~> 2.0' # lower memory background tasks.

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
