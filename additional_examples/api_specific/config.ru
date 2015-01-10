require "rails"
require "action_controller"
# require "active_record"
# require "action_view"
# require "action_mailer"
# require "rails/test_unit"
# require "sprockets"

class MyApp < Rails::Application
  routes.append { root "hello#world" }

  # Eager load. Production style.
  config.eager_load = true

  # This is an API server, so we won't be serving static assets. Setting this to
  # "false" disables the ActionDispatch::Static middleware that does this.
  config.serve_static_files = false

  # Let's say we really care about speed and so want to eliminate as many
  # middleware as we can.

  config.middleware.delete Rack::Sendfile # Only needed if we serve from files
  config.middleware.delete ActionDispatch::Cookies # Not serving browsers
  config.middleware.delete ActionDispatch::Session::CookieStore # See above
  config.middleware.delete ActionDispatch::Flash # only needed if we use flashes
  config.middleware.delete Rack::MethodOverride # only needed for browsers
  config.middleware.delete Rack::Lock # Threadsafe, baby!

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
  include ActionController::Renderers::All # Gives us rendering to :json, :csv
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include AbstractController::Callbacks # Gives us before_filter
  # The below would give us url_for, redirect_to respectively
  # include ActionController::UrlFor
  # include ActionController::Redirecting

  http_basic_authenticate_with name: "admin", password: "secret"

  def world
    render json: "Hello world!".to_json
  end
end

# Initialize the app (originally in config/environment.rb)
MyApp.initialize!

# Print the stack for fun!
puts ">> Starting Rails lightweight stack"
Rails.configuration.middleware.each do |middleware|
  puts "use #{middleware.inspect}"
end
puts "run #{Rails.application.class.name}.routes"

# Run it (originally in config.ru)
run MyApp
