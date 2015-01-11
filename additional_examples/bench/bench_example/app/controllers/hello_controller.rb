class HelloController < ApplicationController

  def world
    render json: "Hello world!".to_json
  end

end
