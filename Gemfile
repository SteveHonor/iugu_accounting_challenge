source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

gem 'rails', '~> 6.0.2', '>= 6.0.2.2'

gem 'mysql2', '>= 0.4.4'

gem 'puma', '~> 4.3'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'jwt'

gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
