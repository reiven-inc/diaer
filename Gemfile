source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'unicorn'
gem 'jquery-rails'
gem 'autoprefixer-rails'
gem 'kaminari'
gem 'counter_culture'
gem 'paperclip'
gem 'paperclip-av-transcoder'
gem 'aws-sdk', '~> 2'
gem 'nokogiri'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'rails4-autocomplete'
gem 'google-api-client', '~> 0.19'
gem 'signet'
gem 'sitemap_generator'
gem 'twitter'
gem 'addressable'
gem 'addressabler', '>= 0.1'
gem 'pry-rails'
