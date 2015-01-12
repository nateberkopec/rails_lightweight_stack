require "rails"
require "action_controller"
#require "ruby-prof"

class MyApp < Rails::Application
  routes.append { root "hello#world" }

  config.cache_classes = true
  config.serve_static_files = false
  config.eager_load = true

  config.middleware.delete Rack::Sendfile # Only needed if we serve from files
  config.middleware.delete ActionDispatch::Cookies # Not serving browsers
  config.middleware.delete ActionDispatch::Session::CookieStore # See above
  config.middleware.delete ActionDispatch::Flash # only needed if we use flashes
  config.middleware.delete Rack::MethodOverride # only needed for browsers
  config.middleware.delete Rack::Lock # Threadsafe, baby!

  config.middleware.delete ActionDispatch::RemoteIp
  config.middleware.delete ActionDispatch::ShowExceptions
  config.middleware.delete ActionDispatch::DebugExceptions
  config.middleware.delete ActionDispatch::Callbacks
  config.middleware.delete ActionDispatch::RequestId
  config.middleware.delete ActionDispatch::ParamsParser
  config.middleware.delete Rack::ConditionalGet
  config.middleware.delete Rack::ETag
  config.middleware.delete Rack::Head

  # Silence deprecation warning about production log levels.
  config.log_level = :error

  # Load only the parts of activesupport Rails needs
  config.active_support.bare

  config.logger = Logger.new(STDOUT)

  # We need a secret token for session, cookies, etc.
  config.secret_key_base = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"
end

class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionController::Renderers::All

  def world
    render json: "Hello world!".to_json
  end
end

MyApp.initialize!

# use Rack::RubyProf, :path => './temp/profile'

puts ">> Starting Rails ultra lightweight stack"
Rails.configuration.middleware.each do |middleware|
  puts "use #{middleware.inspect}"
end
puts "run #{Rails.application.class.name}.routes"

run MyApp
#run HelloController.action(:world)


# HTTP/1.1 200 OK
# Transfer-Encoding: Identity
# Content-Type: text/html
# Server: WEBrick/1.3.1 (Ruby/2.2.0/2014-12-25)
# Connection: close
# Date: Sun, 11 Jan 2015 16:28:24 GMT
# X-Request-Id: 4a53bc41-eed6-456b-928d-8109109d65f8
# X-Runtime: 0.003985
# Cache-Control: max-age=0, private, must-revalidate
# Etag: W/"1297466377ffdf1ccf1ad4995f984f78"


# ab -n 5000 -c 10 http://localhost:3000/

# Server Software:        thin
# Server Hostname:        127.0.0.1
# Server Port:            9292

# Document Path:          /
# Document Length:        14 bytes

# Concurrency Level:      10
# Time taken for tests:   4.832 seconds
# Complete requests:      5000
# Failed requests:        0
# Total transferred:      455000 bytes
# HTML transferred:       70000 bytes
# Requests per second:    1034.68 [#/sec] (mean)
# Time per request:       9.665 [ms] (mean)
# Time per request:       0.966 [ms] (mean, across all concurrent requests)
# Transfer rate:          91.95 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   0.1      0       1
# Processing:     1    9   2.2      9      24
# Waiting:        1    8   2.2      8      18
# Total:          2   10   2.2      9      24

# Percentage of the requests served within a certain time (ms)
#   50%      9
#   66%     10
#   75%     11
#   80%     11
#   90%     12
#   95%     14
#   98%     15
#   99%     17
#  100%     24 (longest request)
