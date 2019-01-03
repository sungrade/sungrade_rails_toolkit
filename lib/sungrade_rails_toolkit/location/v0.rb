module SungradeRailsToolkit
  module Location
    class V0
      attr_reader :data
      extend ApiRequestHelper

      class << self
        def find_or_create(params)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/locations/find_or_create"),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def for_identifiers(*identifiers)
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/locations/search"),
            headers: {"Content-Type" => "application/json"},
            body: {
              identifiers: identifiers.compact
            }.to_json
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/locations/#{identifier}"),
          )
          new(JSON.parse(res.body))
        end
      end

      def initialize(data)
        @data = data
      end

      def identifier
        data.fetch("identifier")
      end

      def longitude
        data.fetch("longitude")
      end

      def latitude
        data.fetch("latitude")
      end

      def address
        data.fetch("address")
      end
    end
  end
end
