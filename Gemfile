source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
gem 'cocoon'
gem 'skim'
gem 'gon'
gem 'bootstrap', '~> 4.5.0'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'
gem 'sidekiq', '< 6'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'unicorn'

gem 'sinatra', require: false
gem 'whenever', require: false
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rubocop-rails', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 4.0.0'
  gem 'factory_bot_rails'
  gem 'dev_log_in'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-email'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'database_cleaner-active_record'
  gem 'launchy'
  gem 'rack_session_access'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
