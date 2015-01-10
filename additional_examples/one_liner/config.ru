%w[rails rack/test action_controller].map{|r|require r};run Class.new(Rails::Application){config.secret_key_base=1;routes.append{root to:proc{[200,{},[]]}}}.initialize!
