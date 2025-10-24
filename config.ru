require "json"
require "rack"

# Load all required files
require_relative "app/controllers/base_controller"
require_relative "app/controllers/products_controller"
require_relative "app/controllers/health_controller"
require_relative "app/middleware/json_body_parser"
require_relative "app/services/product_service"
require_relative "app/models/product"

# Initialize controllers
PRODUCTS_CONTROLLER = ProductsController.new
HEALTH_CONTROLLER = HealthController.new

use Rack::ContentLength
use Rack::Deflater
use JsonBodyParser

map "/health" do 
  run HEALTH_CONTROLLER
end

map "/api/products" do
  run PRODUCTS_CONTROLLER
end

map "/" do
  run proc { |_env|
    [200, { "content-type" => "application/json" }, [JSON.dump({
      message: "Fudo Challenge API",
      version: "1.0.0",
      status: "running",
      endpoints: ["/health", "/api/products"]
    })]]
  }
end

run proc { |_env| 
  [404, { "content-type" => "application/json" }, [JSON.dump({ 
    error: "Not Found",
    message: "Check available endpoints: /health, /api/products"
  })]]
}
