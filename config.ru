# Run this file with:
#
#   RAILS_ENV=production bundle exec rackup -p 3000 -s thin
#
# And access:
#
#   http://localhost:3000/hello/world
#
# We are using Bundler in this example, but we could also
# have used rubygems:
#
#   require "rubygems"
#
#   gem "actionpack"
#   gem "railties"
#
#   require "rails"
#   require "rails/all"

# The following lines should come as no surprise. Except by using
# ActionController::Metal, it follows the same structure of
# config/application.rb, config/environment.rb and config.ru
# existing in any Rails 4 app. Here they are simply in one
# file and without the comments.
require "rails"
# We're only going to load the parts of Rails we need for this example. Usually,
# you would just require "rails/all", requiring all of the below parts at once.
require "action_controller"
# require "active_record"
# require "action_view"
# require "action_mailer"
# require "rails/test_unit"
# require "sprockets"

class MyApp < Rails::Application
  routes.append do
    get "/hello/world" => "hello#world"
  end

  # Eager load. Production style.
  config.eager_load = true

  # Silence deprecation warning about production log levels.
  config.log_level = :debug

  # We need a secret token for session, cookies, etc.
  config.secret_key_base = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"
end

# This is a barebone controller. One good reference can be found here:
# http://piotrsarnacki.com/2010/12/12/lightweight-controllers-with-rails3/
class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering

  def world
    render text: "Hello world!"
  end
end

# Initialize the app (originally in config/environment.rb)
MyApp.initialize!

# Run it (originally in config.ru)
run MyApp
