require "json"
require "jwt"

module SungradeRailsToolkit
  class Token
    extend ApiRequestHelper

    class << self
      def fetch_and_store_token!
        res = post(
          url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "api/internal_authentication/token"),
          headers: {"Content-Type" => "application/json"},
          body: {}.to_json
        )
        token = JSON.parse(res.body)["jwt"]
        SungradeRailsToolkit.store[:jwt] = token
      end
    end
  end
end
