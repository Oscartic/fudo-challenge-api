require "json"
require_relative "base_controller"
require_relative "../services/product_service"

class ProductsController < BaseController
    def initialize(app = nil)
        @product_service = ProductService.new
    end
    
    def call(env)
        request = Rack::Request.new(env)
        
        case [request.request_method, request.path_info]
        when ["POST", "/"], ["POST", "/create"]
          create(env)
        when ["GET", "/"], ["GET", "/list"]
          all
        when ["GET", request.path_info]
          if request.path_info =~ /^\/(\d+)$/
            find_product($1.to_i)
          else
            not_found_response
          end
        else
          not_found_response
        end
    end

    def create(env)
        attrs = env["parsed_body"]
        return bad_request_response(["body is required"]) if attrs.nil? || attrs.empty?

        product, errors = @product_service.create(attrs)
        return unprocessable_entity_response(errors) if errors

        json_response(product, 201)
    end

    def all
        products = @product_service.all
        json_response(products)
    end

    def find_product(id)
        product = @product_service.find(id)
        return not_found_response unless product
        
        json_response(product.to_h)
    end
end