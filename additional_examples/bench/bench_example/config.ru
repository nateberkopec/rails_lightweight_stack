# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

puts ">> Starting Rails default stack"
Rails.configuration.middleware.each do |middleware|
  puts "use #{middleware.inspect}"
end
puts "run #{Rails.application.class.name}.routes"

run Rails.application

# use Rack::Sendfile
# use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x0000010a1d3660>
# use Rack::Runtime
# use Rack::MethodOverride
# use ActionDispatch::RequestId
# use Rails::Rack::Logger
# use ActionDispatch::ShowExceptions
# use ActionDispatch::DebugExceptions
# use ActionDispatch::RemoteIp
# use ActionDispatch::Callbacks
# use ActiveRecord::ConnectionAdapters::ConnectionManagement
# use ActiveRecord::QueryCache
# use ActionDispatch::Cookies
# use ActionDispatch::Session::CookieStore
# use ActionDispatch::Flash
# use ActionDispatch::ParamsParser
# use Rack::Head
# use Rack::ConditionalGet
# use Rack::ETag
# run BenchExample::Application.routes

# HTTP/1.1 200 OK
# X-Content-Type-Options: nosniff
# Content-Type: application/json; charset=utf-8
# Connection: close
# Transfer-Encoding: Identity
# X-Frame-Options: SAMEORIGIN
# X-XSS-Protection: 1; mode=block
# X-Request-Id: b1980a4b-64fe-490a-9bf0-3a3eed86f784
# X-Runtime: 0.002340
# Cache-Control: max-age=0, private, must-revalidate
# Etag: W/"1297466377ffdf1ccf1ad4995f984f78"

# "Hello world!"

# ab -n 5000 -c 10 http://localhost:3000/

# Server Software:
# Server Hostname:        localhost
# Server Port:            3000

# Document Path:          /
# Document Length:        14 bytes

# Concurrency Level:      10
# Time taken for tests:   9.802 seconds
# Complete requests:      5000
# Failed requests:        0
# Total transferred:      1815000 bytes
# HTML transferred:       70000 bytes
# Requests per second:    510.12 [#/sec] (mean)
# Time per request:       19.603 [ms] (mean)
# Time per request:       1.960 [ms] (mean, across all concurrent requests)
# Transfer rate:          180.83 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   0.1      0       4
# Processing:    11   19   2.3     19      39
# Waiting:       11   19   2.3     18      38
# Total:         11   20   2.3     19      40

# Percentage of the requests served within a certain time (ms)
#   50%     19
#   66%     20
#   75%     20
#   80%     21
#   90%     22
#   95%     24
#   98%     26
#   99%     27
#  100%     40 (longest request)
