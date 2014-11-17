source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.5'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'jquery-turbolinks'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'font-awesome-sass' # font awesome icons
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form' # form DSL
gem 'devise' # authentication
gem 'cancancan', '~> 1.8' # authorization
gem 'carrierwave' # media upload
gem 'mini_magick' # rmagick replacement
gem 'fog' # cloud services api
gem 'unf' # fog string encoding
gem 'mime-types' # mime types for carrierwave
gem 'rollbar' # application error tracking
gem 'newrelic_rpm' #system monitoring
gem 'chronic' # date/time with sexy syntax
gem 'cocoon' # unobtrusive nested forms handling, using jQuery
gem 'select2-rails' # clean select menus
gem 'acts-as-taggable-on' # tagging
gem 'stripe' # cc processing
gem 'draper', '~> 1.3' # model decoration
gem 'kaminari' # pagination
gem 'bootstrap-kaminari-views'
gem 'analytics-ruby', '~>1.0' # segement.io
gem 'high_voltage', '~> 2.2.0' # static pages
gem 'fedex' # fedex api
gem 'colorize' # colorful logs
gem 'feedjira'

group :development do
  gem 'spring'
  gem 'quiet_assets'
  gem 'bullet'
  gem 'letter_opener'
  gem 'annotate', '~> 2.6.5'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'pry-rails'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda'
  gem 'valid_attribute'
  gem 'stripe-ruby-mock', '~> 1.10.1.7' # builds fake Stripe customer
  # gem 'vcr'
  # gem 'webmock'
end

group :production do
  gem 'unicorn', '4.6.3' # rack http server
  gem 'rails_12factor'
end
