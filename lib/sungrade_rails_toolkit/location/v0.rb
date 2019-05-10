module SungradeRailsToolkit
  module Location
    class V0
      attr_reader :data
      extend ApiRequestHelper

      class << self
        def find_or_create(params)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/locations/find_or_create"),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def for_identifiers(*identifiers)
          search({identifiers: identifiers.compact})
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/locations/#{identifier}"),
          )
          new(JSON.parse(res.body))
        end

        def search(params)
          body = params.is_a?(String) ? params : params.to_json
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/locations/search"),
            headers: {"Content-Type" => "application/json"},
            body: body
          )
          JSON.parse(res.body).map { |user| new(user) }
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
