module SungradeRailsToolkit
  module Region
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def internal_all
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/regions"),
            headers: {"Content-Type" => "application/json"},
          )
          JSON.parse(res.body).fetch("data").map { |user| new(user) }
        end

        def for_identifiers(*identifiers)
          search({
            identifiers: identifiers
          })
        end

        def for_zip_code(zip_code)
          for_zip_codes(zip_code)
        end

        def for_zip_codes(*zip_codes)
          search({
            zip_codes: zip_codes
          })
        end

        def search(body)
          body = body.is_a?(String) ? body : body.to_json
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/regions/search"),
            headers: {"Content-Type" => "application/json"},
            body: body
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/regions/#{identifier}"),
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
