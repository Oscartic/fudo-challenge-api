class BaseController
    def initialize(app = nil)
        @app = app
    end

    def json_response(body, status = 200)
        [status, { "content-type" => "application/json" }, [JSON.dump(body)]]
    end

    def not_found_response
        [404, { "content-type" => "application/json" }, [JSON.dump({ error: "not found" })]]
    end

    def bad_request_response(errors)
        [400, { "content-type" => "application/json" }, [JSON.dump({ errors: errors })]]
    end

    def unprocessable_entity_response(errors)
        [422, { "content-type" => "application/json" }, [JSON.dump({ errors: errors })]]
    end

    def internal_server_error_response(errors)
        [500, { "content-type" => "application/json" }, [JSON.dump({ errors: errors })]]
    end
end