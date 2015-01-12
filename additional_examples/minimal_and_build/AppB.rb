require "minitest"
require "minitest/autorun"
require "rack/test"
require "rails" # need to bring this in so we can subclass Rails::Application
require "action_dispatch" # not loading ActionController yet. Only routing.

class Appb < Rails::Application # Defining the App constant, just like before.

  # This is normally in config/routes.rb.
  routes.append { root to: proc{ [200,{},[%q[{"Hello":"World!"}]]] }  }
  # If you didn't know you could route to a proc, now you do! In fact, you can
  # route to any Rack app!

  config.eager_load = false # Rails warns us when we don't set this.

  # If we don't include the below line, Rails will try to add the
  # ActionDispatch::Static middleware, which tries to use ActionController.
  # We haven't loaded ActionController, so we're going to set this to false.
  config.serve_static_files = false
  # We need a secret token for session, cookies, etc.
  config.secret_key_base = "notsecure"
end

# Initialize the app (originally in config/environment.rb)
Appb.initialize!

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Appb
  end

  def test_hello_world
    get "/"

    assert_equal %q[{"Hello":"World!"}], last_response.body
    assert last_response.ok?
  end

end
