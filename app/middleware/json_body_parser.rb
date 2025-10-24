require "json"
require "rack"

class JsonBodyParser
    def initialize(app)
        @app = app
    end

    def call(env)
        request = Rack::Request.new(env)
        content_type = request.content_type.to_s
        
        if content_type.include?("application/json")
            body = request.body.read
            
            request.body.rewind if request.body.respond_to?(:rewind)
            
            unless body.strip.empty?
                begin
                    env["parsed_body"] = JSON.parse(body)
                rescue JSON::ParserError => e
                    return [400, { "content-type" => "application/json" }, [JSON.dump({ error: "Invalid JSON" })]]
                end
            end
        end
        
        @app.call(env)
    end
end