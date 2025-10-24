require_relative "base_controller"

class HealthController < BaseController
  def call(env)
    health_data = {
      status: "healthy",
      timestamp: Time.now.iso8601,
      uptime: Process.clock_gettime(Process::CLOCK_MONOTONIC),
      version: "1.0.0"
    }
    
    json_response(health_data)
  end
end