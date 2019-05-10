module SungradeRailsToolkit
  module Email
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def create(user_id:, params:)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/users/#{user_id}/emails"
            ),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def update(id:, params:)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/emails/#{id}"
            ),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def destroy(id:)
          res = delete(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/emails/#{id}"
            ),
            headers: {"Content-Type" => "application/json"}
          )
        end

        def for_identifiers(*identifiers)
          res = put(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/emails/search"
            ),
            headers: {"Content-Type" => "application/json"},
            body: {
              identifiers: identifiers.compact
            }.to_json
          )
          JSON.parse(res.body).map { |user| new(user) }
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/emails/#{identifier}"
            ),
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
