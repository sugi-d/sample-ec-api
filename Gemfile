source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use Unicorn as the app server
gem 'unicorn', '~> 5.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use mysql2 as the database for Active Record
gem 'mysql2', '>= 0.4.6', '< 0.5'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Use Redis
gem 'redis-rails'
# Use JWT authentication
gem 'knock'

# Use Pagination
gem 'kaminari'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'guard-rspec'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  # a mini view framework for console applications and uses it to improve ripl(irb)'s default inspect output
  gem 'hirb'
  gem 'hirb-unicode'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
