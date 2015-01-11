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
  config.middleware.delete ActionDispatch::ParamsParser
  config.middleware.delete Rack::ConditionalGet
  config.middleware.delete Rack::ETag
  config.middleware.delete Rack::Head

  # Silence deprecation warning about production log levels.
  config.log_level = :debug

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

#use Rack::RubyProf, :path => './temp/profile'

run MyApp

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

# Server Software:
# Server Hostname:        localhost
# Server Port:            3000

# Document Path:          /
# Document Length:        14 bytes

# Concurrency Level:      10
# Time taken for tests:   7.333 seconds
# Complete requests:      5000
# Failed requests:        0
# Total transferred:      750000 bytes
# HTML transferred:       70000 bytes
# Requests per second:    681.82 [#/sec] (mean)
# Time per request:       14.667 [ms] (mean)
# Time per request:       1.467 [ms] (mean, across all concurrent requests)
# Transfer rate:          99.88 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   6.2      0     244
# Processing:     5   14   2.1     14      31
# Waiting:        3   12   1.9     12      28
# Total:          5   15   6.5     14     258

# Percentage of the requests served within a certain time (ms)
#   50%     14
#   66%     15
#   75%     16
#   80%     16
#   90%     17
#   95%     18
#   98%     19
#   99%     20
#  100%    258 (longest request)
