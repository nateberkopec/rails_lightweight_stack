# [fit] Rails
# [fit] From the Ground
# [fit] Up

with @nateberkopec

---

# [fit] Rails is
# [fit] bloated

![](img/pufferfish.jpg)

^ Rails has a reputation
^ Big
^ Slow
^ Not Web Scale

---

> Rails is over. It's a bloated meta framework that requires enormous amounts of peripheral knowledge to understand.
-- Hacker News

^ What's a meta framework?

---

> [Lotus] aims to bring back Object Oriented Programming to web development
-- Lotus web framework

^ Lotus is a small project, never really caught on. But I think it makes some
^ interesting claims.
^ Bringing OOP back like JT
^ Where did OOP go?
^ Implying Rails isn't OOP

---

> Lotus is made of standalone frameworks (controllers, views, etc.)
-- Lotus web framework

^ I don't think they knew Rails is made of several standalone frameworks.

---

> Lotus is lightweight, fast and testable.
-- Lotus web framework

^ I think they're implying that Rails can't be lightweight and fast.

---

# Rails is a massive project

* Rails: 49,104 commits and 2,551 contributors
* Sinatra: 2,664 commits and 225 contributors
* Node: 10,222 commits and 548 contributors
* Express: 4,974 commits and 165 contributors
* Ruby: 38,223 commits and 38 (?) contributors

^ I want to use 10 years, 50,000 commits, and 2,500 contributors in production
^ I also don't want it to feel bloated

---

> "Rails will become more modular, starting with a rails-core, and including the ability to opt in or out of specific components."
-- Yehuda Katz, 2008

^ History lesson!
^ Rails 3 release in August 2010

---

> All forward progress stalled for nearly two years, it's *still* slower than Rails 2, Bundler is a nightmare, Node.js won
-- Jeremy Ashkenas, 2012

^ Its not slower anymore, bundler is awesome
^ but he's right about forward progress

---

# [fit] Rails is
# [fit] bloated*

*If you let it.

---

# What do we get when we use rails new?

* Empty folders, reminding us where Rails expects to find things
* Placeholder files like application.js and application.css,
application.html.erb, the application helper and application controller, a
locale file, seeds.rb.

---

# What do we get when we use rails new?

* Public folder with a favicon, 404/500 pages, robots.txt
* Initializers and config files for different environments
* Gemfile
* Rakefile

---

# What do we get when we use rails new _that matters?_

* config.ru
* config/routes.rb
* config/application.rb
* config/boot.rb
* config/environment.rb

http://guides.rubyonrails.org/initialization.html

---

# [fit] Lets compress five files
# [fit] into one!

---

# Gemfile

```ruby
source "https://rubygems.org"

gem "rails", "~> 4.2"
```

This puts a *lot* of stuff in the Gemfile.lock

---

# config.ru

```ruby
# normally happens in application.rb via "require 'rails/all'"
require "rails"
require "action_dispatch"
# require "active_controller"
# require "active_record"
# require "action_view"
# require "action_mailer"
# require "active_job"
# require "rails/test_unit"
# require "sprockets"
```

^ remember Lotus is made of standalone frameworks (controllers, views, etc.)?

---

```ruby
# also happens in application.rb
class MyApp < Rails::Application
  # config/routes.rb
  routes.append { root to: Proc.new { [200,[],["Hello world!"]] } }

  config.serve_static_files = false

  # We need a secret token for session, cookies, etc.
  # Usually via config/secrets.yaml
  config.secret_key_base = "insecure"
end
```
^ Yes you can mount Rack apps directly to routes
^ Recall the Rack spec.
^ A Rack application is a Ruby object (not a class) that responds to call.
^ It takes exactly one argument, the environment and returns an Array of exactly
^ three values: The status, the headers, and the body.
^ If we don't include the below line, Rails will try to add the
^ ActionDispatch::Static middleware, which tries to use ActionController.
^ We haven't loaded ActionController, so we're going to set this to false


---

# Recap

```ruby
# config.ru
require "rails"
require "action_dispatch"

class MyApp < Rails::Application
  routes.append { root to: Proc.new { [200,[],["Hello world!"]] } }
  config.serve_static_files = false
  config.secret_key_base = "insecure"
end
```

---

```ruby
# config/environment.rb
MyApp.initialize!

# config.ru
run MyApp
```

---

# Recap

```ruby
# config.ru
require "rails"
require "action_dispatch"

class MyApp < Rails::Application
  routes.append { root to: Proc.new { [200,[],["Hello world!"]] } }
  config.serve_static_files = false
  config.secret_key_base = "insecure"
end

# config/environment.rb
MyApp.initialize!

# config.ru
run MyApp
```

---

```
bundle exec rackup
````

```
$ katana:~ nateberkopec$ curl 127.0.0.1:9292
Hello world!
$ katana:~ nateberkopec$ nateberkopec$ curl -I 127.0.0.1:9292
HTTP/1.1 200 OK
Content-Type: text/html
ETag: W/"86fb269d190d2c85f6e0468ceca42a20"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: e92f0ec1-d373-4af9-9b0d-1df14f265b78
X-Runtime: 0.000824
Transfer-Encoding: chunked
Connection: close
Server: thin
```

---
```ruby
use Rack::Sendfile
use #<ActiveSupport::Cache:...>
use Rack::Runtime
use Rack::MethodOverride
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::RemoteIp
use ActionDispatch::Callbacks
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore
use ActionDispatch::Flash
use ActionDispatch::ParamsParser
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
```

^ Rack Sendfile lets our web server (nginx) serve static assets instead of our app server
^ Activesupport adds some real basic caching for when we call cache in the app
^ Rack::Runtime sets X-Runtime
^ RemoteIp prevents IP spoofing attacks, any client can claim to have any IP address by setting the X-Forwarded-For header. we dont need this on heroku w/ssl.

---

```ruby
class MyApp < Rails::Application
  config.middleware.delete ActionDispatch::Cookies
end
```

---

```ruby
class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering

  def world
    render text: "Hello world!"
  end
end
```
---

# ActionController::Metal

* Inherits from AbstractController::Base
* Doesn't include a lot of the things you normally get in Rails controllers
* No layouts, no render, no nothin'

^ Actioncontroller base does stuff like define

---

# All controllers are also Rack apps

```ruby
class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering

  def world
    render text: "Hello world!"
  end
end

run HelloController.action(:world)
# get 'hello', 'hello#index'
# get 'hello', to: HelloController.action(:index)
```

---

AbstractController::Rendering,AbstractController::Translation,AbstractController::AssetPaths,Helpers,HideActions,UrlFor,Redirecting,ActionView::Layouts,Rendering,Renderers::All,ConditionalGet,EtagWithTemplateDigest,RackDelegation,Caching,MimeResponds,ImplicitRender,StrongParameters,Cookies,Flash,RequestForgeryProtection,ForceSSL,Streaming,DataStreaming,AbstractController::Callbacks,Rescue,Instrumentation,ParamsWrapper

^ Also the HTTP basic modules

---
# Recap

```ruby
require "rails"
require "action_controller"

class MyApp < Rails::Application
  routes.append { root "hello#world" }
  config.secret_key_base = "insecure"
end

class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering

  def world
    render text: "Hello world!"
  end
end

MyApp.initialize!

run MyApp
```
---

# What do we get in return?

* Remote IP spoofing protection, timing attack prevention via _ActionDispatch::RemoteIp_
* Automatic reloading in development
* Environments
* Excellent logging (_ActionDispatch::RequestId_, _ActionDispatch::DebugExceptions_)
* Parameter parsing via _ActionDispatch::ParamsParser_
* Conditional GET (_Rack::ConditionalGet_)

---

# What do we get in return?

* Caching (_Rack::Cache_ and _Rack::ETag_)
* HEAD requests to GET via _Rack::Head_
* Resourceful routes
* URL generation and URL helpers
* Basic, Token, Digest HTTP auth
* A great instrumentation API
* Generators
* Incredibly simple extensibility
* Access to the Rails ecosystem (Engines, gems)

---

# Memory differences (Thin)

* 40.1 MB lightweight Rails
* 70.7 MB stock Rails
* 26.7 MB Sinatra

Most of the difference between Rails and Sinatra at this point is ActiveSupport

---

# Speed differences from stock Rails on a microbench

* Lightweight Rails ~10% faster
* Ultra Lightweight Rails ~90% faster (remove all middleware, log to stdout)
* Sinatra ~100% faster

_But_ these differences are on the order of single-digit milliseconds. App code > Framework code.

---

# Why is this modularity interesting?

* Improves your understanding of Rails internals
* Faster and uses less memory
* Win arguments with internet haters
* Yehuda spent 2 years on it, be grateful

---

# Your homework

* Don't use rails/all
* Consider ActionController::Metal
* Try starting from a single file the next time your start a Rails app

---

# [fit] Thanks
# [fit] for
# [fit] Listening!

twitter/github: @nateberkopec

---

# Bonus: tweet-length Rails apps

```ruby

require "rails/all"
run Class.new (Rails::Application) do
  routes.append{root to:proc{[200,{},[]]}}
end.initialize!

```

This example requires a secrets.yml and gemfile (and the gemfile can't contain ActiveRecord)

---

# Bonus: tweet-length Rails apps

```ruby

%w[rails rack_test action_controller].map{|r|require r}
run Class.new (Rails::Application) do
  config.secret_key_base=1
  routes.append{root to:proc{[200,{},[]]}}
end.initialize!

```

This example can be run from a single file!

---

# Expanding: ActiveModel

```ruby
class Article
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  attr_accessor :id, :name, :content

  def self.all
    @articles ||= []
  end

  ...etc
end

```

---

# Expanding: ActiveRecord

* Add config/database.yml
* Set up your database
* Require ActiveRecord
* Add a Rakefile and call ```Rails.application.load_tasks```

---

# Expanding: ActionView

```ruby
class HelloController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionView::Layouts
  append_view_path "#{Rails.root}/app/views"

  def index
    render "hello/index"
  end
end
```

---

# Expanding: Rails Server

* Add back bin/rails and you're set

---

# Expanding: ActionMailer

* Just require ActionMailer and get to it

---

# Expanding: Tests

* You can do tests in-file, or just require the test support (or your favorite test gem) and hop to it
