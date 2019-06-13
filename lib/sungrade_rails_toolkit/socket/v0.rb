module SungradeRailsToolkit
  module Socket
    class V0
      extend ApiRequestHelper
      class << self
        def push_messages(messages:)
          body = { messages: messages }
          post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/socket_messages"),
            headers: {"Content-Type" => "application/json"},
            body: body.to_json
          )
        end
      end
    end
  end
end
