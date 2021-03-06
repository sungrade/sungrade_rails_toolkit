module SungradeRailsToolkit
  module Office
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def internal_all
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/offices"),
            headers: {"Content-Type" => "application/json"},
          )
          JSON.parse(res.body).fetch("data").map { |user| new(user) }
        end

        def for_identifiers(*identifiers)
          search({
            identifiers: identifiers
          })
        end

        def search(body)
          body = body.is_a?(String) ? body : body.to_json
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/offices/search"),
            headers: {"Content-Type" => "application/json"},
            body: body
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/offices/by_identifier/#{identifier}"),
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

      def regions
        @regions ||= data.fetch("regions").map { |data| Region::V0.new(data) }
      end
    end
  end
end
