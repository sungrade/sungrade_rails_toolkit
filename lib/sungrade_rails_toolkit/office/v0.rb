module SungradeRailsToolkit
  module Office
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def internal_all
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_offices"),
            headers: {"Content-Type" => "application/json"},
          )
          JSON.parse(res.body).fetch("data").map { |user| new(user) }
        end

        def for_identifiers(*identifiers)
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_offices/search"),
            headers: {"Content-Type" => "application/json"},
            body: {
              identifiers: identifiers.compact
            }.to_json
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_offices/by_identifier/#{identifier}"),
          )
          new(JSON.parse(res.body))
        end
      end

      def initialize(data)
        @data = data
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
