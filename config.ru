require "json"
require "rack"

use Rack::ContentLength
use Rack::Deflater

map "/health" do 
    run proc { |_env| 
        [200, { "content-type" => "application/json" }, [JSON.dump({ message: "OK" })]]
    } 
end


run proc { |_env| 
    [404, { "content-type" => "application/json" }, [JSON.dump({ message: "Not Found" })]] 
}
