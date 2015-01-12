require "minitest"
require "minitest/autorun"
require "rack/test"
require "rails"
require "action_controller" # We're going to define a controller now

class Appc < Rails::Application

  routes.append { root "hello#world" } # this should be familiar

  config.eager_load = false
  config.serve_static_files = false
  config.secret_key_base = "notsecure"
end

# ActionController::Base inherits from ActionController::Metal. AC::Base is
# basically just AC::Metal with a lot of modules included, that do things like
# force SSL, give us strong parameters, URL helpers, layouts, and a whole lot
# else (go read the source for a full list). ActionController::Metal basically
# is just a fancy wrapper around a Rack app (you can even mount controllers, see
# the example below).

class HelloController < ActionController::Metal
  # These two modules are needed for us to call render
  include AbstractController::Rendering
  include ActionController::Rendering

  # This gives us the ability to call render :json. Recall that this sets the
  # content type, etc.
  include ActionController::Renderers::All

  def world
    render json: {"Hello" => "World!"}.to_json
  end
end

# Initialize the app (originally in config/environment.rb)
Appc.initialize!

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Appc
  end

  def test_hello_world
    get "/"

    puts last_response
    assert_equal %q[{"Hello":"World!"}], last_response.body
    assert last_response.ok?
  end
end
