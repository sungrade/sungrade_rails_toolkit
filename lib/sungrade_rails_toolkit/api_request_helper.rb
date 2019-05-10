require "faraday"

module SungradeRailsToolkit
  module ApiRequestHelper
    def validate_response!(response)
      raise UnsuccessfulResponse.new(response: response) unless response.success?
    end

    %w[get head delete post put patch].each do |meth|
      define_method(meth) do |url:, body: {}, headers: {}, validate_response: true, &blk|
        run_request(
          verb: meth,
          url: url,
          body: body,
          validate_response: validate_response,
          headers: headers,
          &blk
        )
      end
    end

    def run_request(verb:, url:, body:, headers:, validate_response: true)
      response = connection.send(verb, url, body, headers) do |req|
        headers = {
          "X-Request-Id" => SungradeRailsToolkit.store.request_id,
          "Authorization" => "Bearer #{SungradeRailsToolkit.store.jwt}",
          "Client-Id" => SungradeRailsToolkit.config.api_gateway_token
        }

        req.headers.merge!(headers)
        yield(req) if block_given?
      end
      validate_response!(response) if validate_response
      response
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.use(Faraday::Response::Logger) if ENV["SHOW_CONNECTION_INFO"]
        faraday.adapter(Faraday.default_adapter)
      end
    end
  end
end
