require "rails"
require "action_controller"

class MyApp < Rails::Application
  routes.append { root "hello#world" }

  config.serve_static_files = false
  config.eager_load = true

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

class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionController::Renderers::All

  def world
    render json: "Hello world!".to_json
  end
end

MyApp.initialize!

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


# ab -n 5000 -c 100 http://localhost:3000/

# Server Software:
# Server Hostname:        localhost
# Server Port:            3000

# Document Path:          /
# Document Length:        14 bytes

# Concurrency Level:      10
# Time taken for tests:   9.278 seconds
# Complete requests:      5000
# Failed requests:        0
# Total transferred:      1230000 bytes
# HTML transferred:       70000 bytes
# Requests per second:    538.93 [#/sec] (mean)
# Time per request:       18.555 [ms] (mean)
# Time per request:       1.856 [ms] (mean, across all concurrent requests)
# Transfer rate:          129.47 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   0.2      0       2
# Processing:     5   18   2.9     18      38
# Waiting:        3   16   2.4     16      38
# Total:          6   18   2.9     18      39

# Percentage of the requests served within a certain time (ms)
#   50%     18
#   66%     19
#   75%     20
#   80%     21
#   90%     22
#   95%     23
#   98%     26
#   99%     27
#  100%     39 (longest request)
