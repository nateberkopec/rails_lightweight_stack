require "minitest"
require "minitest/autorun"
require "rack/test"
require "rails"
require "action_controller"

class Appd < Rails::Application

  routes.append { get "hello" => "hello#world" } # this should be familiar

  config.eager_load = false
  config.serve_static_files = false
  config.secret_key_base = "notsecure"

  # Normally the Rails server command adds this middleware. We have to add it
  # ourselves.
  config.middleware.use Rack::ContentLength
end

class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionController::Renderers::All

  # Lets a lot of calls pass thru to the Rack response object directly. This lets
  # us set content-type, set headers, etc.
  include ActionController::RackDelegation

  def world
    render json: {"Hello" => "World!"}.to_json
  end
end

# Initialize the app (originally in config/environment.rb)
Appd.initialize!

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Appd
  end

  def test_hello_world
    get "/hello.json"

    assert_equal %q[{"Hello":"World!"}], last_response.body
    assert last_response.ok?
  end

  def test_rails_middleware_added
    get "/hello.json"

    assert last_response["X-Request-Id"]
    assert last_response["X-Runtime"]
    assert last_response["X-Xss-Protection"]
    assert last_response["Cache-Control"]
    assert last_response["X-Content-Type-Options"]
    assert last_response["X-Frame-Options"]
    assert last_response["ETag"]
    assert_equal "18", last_response["Content-Length"]
  end

  def test_content_type_hello_world
    get "/hello.json"

    assert_equal "application/json; charset=utf-8", last_response["Content-Type"]
  end

  def test_404
    get "/invalid"

    assert_equal 404, last_response.status
  end

  def test_head
    head "/hello.json"

    assert_equal "", last_response.body
    assert last_response.ok?
  end
end
