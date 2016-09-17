use_local_gem = (ENV['USE_LOCAL'] || '') != ''

source 'https://rubygems.org'

gem 'puma'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# jQuery UI assets, like animation easing
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'jquery-turbolinks'
# turbolinks with document ready

gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'bootstrap-sass', '3.3.6'

# gem 'bootstrap', '~> 4.0.0.alpha3'

gem 'curb'

# gem 'sprockets-rails', :require => 'sprockets/railtie'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'summernote-rails', '~> 0.8.1.1'

# font awesome
gem 'font-awesome-sass', '~> 4.6.2'

# d3 for rails
gem 'd3-rails'

# Access an IRB console on exception pages or by using <%= console %> in views
gem 'web-console', '~> 2.0'

# Rails-api
gem 'rails-api'

if use_local_gem

  gem 'archare_ui', path: '../archare_ui'

  gem 'archare',    path: '../archare'
else

  gem 'archare_ui', '0.2.1'

  gem 'archare',    '0.1.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.5'
end


group :production do
  # Use PosxtgreSQL as the database for Active Record
  gem 'pg', '~> 0.18.4'

  # By default Rails 4 will not serve your assets. this can help
  gem 'rails_12factor'

  # gem 'web-console', '~> 2.0'
end
