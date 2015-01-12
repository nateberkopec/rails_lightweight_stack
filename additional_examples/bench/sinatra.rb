require 'sinatra'
require "sinatra/json"
# require "ruby-prof"

set :server, 'thin'

# use Rack::RubyProf, :path => './temp/profile_sinatra'

get '/' do
  json "Hello World!"
end

# HTTP/1.1 200 OK
# X-Content-Type-Options: nosniff
# Connection: close
# Content-Type: application/json
# Content-Length: 14
# Server: WEBrick/1.3.1 (Ruby/2.2.0/2014-12-25)
# Date: Sun, 11 Jan 2015 16:28:08 GMT

# "Hello World!"

# ab -n 5000 -c 10 http://localhost:4567/

# Server Software:
# Server Hostname:        localhost
# Server Port:            4567

# Document Path:          /
# Document Length:        14 bytes

# Concurrency Level:      10
# Time taken for tests:   4.098 seconds
# Complete requests:      5000
# Failed requests:        0
# Total transferred:      685000 bytes
# HTML transferred:       70000 bytes
# Requests per second:    1220.23 [#/sec] (mean)
# Time per request:       8.195 [ms] (mean)
# Time per request:       0.820 [ms] (mean, across all concurrent requests)
# Transfer rate:          163.25 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   0.1      0       1
# Processing:     2    8   4.9      7     103
# Waiting:        1    5   4.6      5      98
# Total:          2    8   4.9      8     103

# Percentage of the requests served within a certain time (ms)
#   50%      8
#   66%      9
#   75%      9
#   80%     10
#   90%     12
#   95%     13
#   98%     15
#   99%     18
#  100%    103 (longest request)
