require 'rack/body_proxy'

module SungradeRailsToolkit
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      SungradeRailsToolkit.begin!
      SungradeRailsToolkit.serialize_from_env!(env)

      response = @app.call(env)

      returned = response << Rack::BodyProxy.new(response.pop) do
        SungradeRailsToolkit.end!
        SungradeRailsToolkit.clear!
      end
    ensure
      unless returned
        SungradeRailsToolkit.end!
        SungradeRailsToolkit.clear!
      end
    end
  end
end
