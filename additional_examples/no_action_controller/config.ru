require "rails"
require "action_dispatch" # not loading ActionController saves us about 5MB per process

class MyApp < Rails::Application
  routes.append { root to: proc{ [200,{},["Hello world!"]] }  }

  # We need a secret token for session, cookies, etc.
  config.secret_key_base = "whatever"
end

# Initialize the app (originally in config/environment.rb)
MyApp.initialize!

# Run it (originally in config.ru)
run MyApp
