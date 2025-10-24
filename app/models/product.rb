class Product 
    attr_reader :id
    attr_accessor :name, :price 
    
    def initialize(id, name, price)
        @id = id
        @name = name
        @price = price
    end

    def to_h 
        { id: @id, name: @name, price: @price }
    end

    def valid?
        errors = {}
        errors["name"] = "is required" if @name.nil? || @name.strip.empty?

        if @price.nil?
            errors["price"] = "is required"
        elsif @price <= 0
            errors["price"] = "must be greater than 0"
        end

        errors
    end
end