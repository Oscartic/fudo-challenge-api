require "thread"
require_relative "../models/product"

class ProductService
    def initialize 
        @seq = 0 
        @products = {}
        @mutex = Mutex.new
    end
    
    def all
        @mutex.synchronize do
            @products.values.map(&:to_h)
        end
    end

    def create(attrs)
        name = (attrs["name"] || attrs[:name]).to_s.strip
        price = attrs["price"] || attrs[:price]
        errors = {}
        
        errors["name"] = "is required" if name.empty?
        
        if price.nil? || price.to_s.strip.empty?
            errors["price"] = "is required"
        else
            begin
                price = Float(price)
                errors["price"] = "must be greater than 0" if price <= 0
            rescue
                errors["price"] = "is not a valid number"
            end
        end

        return [nil, errors] if errors.any?

        product = nil
        @mutex.synchronize do
            product = Product.new(@seq += 1, name, price)
            @products[product.id] = product
        end
        [product.to_h, nil]
    end

    def find(id)
        @mutex.synchronize do
            @products[id]
        end
    end
end
