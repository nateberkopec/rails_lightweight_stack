# Run this file with:
#
#   RAILS_ENV=production bundle exec rackup -p 3000 -s thin
#
# And access:
#
#   http://localhost:3000/hello/world
#
# This example app follows the same structure of config/application.rb,
# config/environment.rb and config.ru that exists in any Rails 4 app. Here,
# we're just doing it in one file.
#
# We're only going to load the parts of Rails we need for this example. Usually,
# you would just require "rails/all", requiring all of the below parts at once.
# I've commented out the parts that would normally be loaded by "rails/all".
require "action_controller/railtie"
# require "active_record"
# require "action_view"
# require "action_mailer"
# require "active_job"
# require "rails/test_unit"
# require "sprockets"

class MyApp < Rails::Application
  routes.append { root "hello#world" }

  # Eager load. Production style.
  config.eager_load = true

  # Remove any HTML-related middleware
  config.api_only = true

  # Silence deprecation warning about production log levels.
  config.log_level = :debug

  # We need a secret token for session, cookies, etc.
  config.secret_key_base = "whatever"
end

# This is a barebone controller. One good reference can be found here:
# http://piotrsarnacki.com/2010/12/12/lightweight-controllers-with-rails3/
class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering

  def world
    render plain: "Hello world!"
  end
end

# Initialize the app (originally in config/environment.rb)
MyApp.initialize!

# Run it (originally in config.ru)
run MyApp
