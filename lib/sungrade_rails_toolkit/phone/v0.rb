module SungradeRailsToolkit
  module Phone
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def find_or_create(params)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_phones/find_or_create"),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def for_identifiers(*identifiers)
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_phones/search"),
            headers: {"Content-Type" => "application/json"},
            body: {
              identifiers: identifiers.compact
            }.to_json
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_phones/by_identifier/#{identifier}"),
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

      def update(params)
        body = params.is_a?(String) ? params : params.to_json
        res = post(
          url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/api/v0/internal_phones/by_identifier/#{identifier}"),
          headers: {"Content-Type" => "application/json"},
          body: body
        )
        set_body!(JSON.parse(res.body))
      end

      def set_body!(data)
        if data.fetch("identifier") == identifier
          @data = data
          self
        else
          self.class.new(data)
        end
      end
    end
  end
end
