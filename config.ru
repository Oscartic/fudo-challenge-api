require "json"
require "rack"
require "pry"

require_relative "app/json_body_parser"
require_relative "app/product_repository"

STORE = ProductRepository.new

use Rack::ContentLength
use Rack::Deflater
use JsonBodyParser

map "/health" do 
    run proc { |_env| 
        [200, { "content-type" => "application/json" }, [JSON.dump({ message: "OK" })]]
    } 
end

# /products
map "/products" do
    run proc { |env|
      req = Rack::Request.new(env)

    #   binding.pry  
      
    case [req.request_method, req.path_info]
    when ["GET", "/"], ["GET", "/list"]
        # Lista de productos
        [200, { "content-type" => "application/json" }, [JSON.dump(STORE.all)]]
        
    when ["POST", "/"], ["POST", "/create"]
        payload = env["parsed_body"] || {}
        created, errors = STORE.create(payload)
        if errors
          [422, { "content-type" => "application/json" }, [JSON.dump({ errors: errors })]]
        else
          headers = {
            "content-type" => "application/json",
            "location"     => "/products/#{created[:id]}"
          }
          [201, headers, [JSON.dump(created)]]
        end
  
    else
        [404, { "content-type" => "application/json" }, [JSON.dump({ error: "not found" })]]
    end
    }
  end

run proc { |_env| 
    [404, { "content-type" => "application/json" }, [JSON.dump({ message: "Not Found, please ckeck ep" })]] 
}
