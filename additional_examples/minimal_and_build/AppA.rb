# Run this file with "bundle exec rackup Appa.rb" to run the serve
# Run this file with "bundle exec ruby Appa.rb" to run the tests

require "minitest" # Need to bring our testing library
require "minitest/autorun" # Needed so that our minitest tets run automatically
require "rack/test" # Rack testing library. Lets us call "get".

# A Rack application is a Ruby object (not a class) that responds to call.
# It takes exactly one argument, the environment and returns an Array of exactly
# three values: The status, the headers, and the body.
# http://www.rubydoc.info/github/rack/rack/file/SPEC

Appa = Proc.new { [200,[],[%q[{"Hello":"World!"}]]] }

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Appa
  end

  def test_hello_world
    get "/"

    assert_equal %q[{"Hello": "World!"}], last_response.body
    assert last_response.ok?
  end

end
