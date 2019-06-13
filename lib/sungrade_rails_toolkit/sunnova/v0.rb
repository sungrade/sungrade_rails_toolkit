module SungradeRailsToolkit
  module Sunnova
    class V0
      extend ApiRequestHelper

      class << self
        def create_lead(params:)
          params = params.is_a?(String) ? params : params.to_json
          post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/sunnova/leads"),
            body: params,
            headers: {"Content-Type" => "application/json"},
          )
        end

        def update_lead(params:, lead_id:)
          params = params.is_a?(String) ? params : params.to_json
          put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/sunnova/leads/#{lead_id}"),
            body: params,
            headers: {"Content-Type" => "application/json"},
          )
        end

        def list_equipment
          get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/sunnova/equipment"),
          )
        end

        def build_lead_systems(lead_id:, body:)
          post(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/sunnova/lead_systems"
            ),
            headers: {"Content-Type" => "application/json"},
            body: {
              sunnova_body: body,
              lead_id: lead_id,
            }.to_json
          )
        end

        def create_lead_quote(lead_system_id:, body:)
          post(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/sunnova/lead_quotes"
            ),
            headers: {"Content-Type" => "application/json"},
            body: {
              sunnova_body: body,
              lead_system_id: lead_system_id,
            }.to_json
          )
        end

        def fetch_lead_quote(lead_quote_id:)
          get(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/sunnova/lead_quotes/#{lead_quote_id}"
            ),
          )
        end

        def rate_plans_for(lead_id:, lse_id:)
          get(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/sunnova/utilities/rate_plans?lead_id=#{lead_id}&lse_id=#{lse_id}"
            )
          )
        end

        def update_utility_information(lead_id:, lse_id:, body:)
          post(
            url: File.join(
              SungradeRailsToolkit.config.api_gateway_base_url,
              "/internal_api/v0/sunnova/utilities"
            ),
            headers: {"Content-Type" => "application/json"},
            body: {
              sunnova_body: body,
              lead_id: lead_id,
              lse_id: lse_id
            }.to_json
          )
        end
      end
    end
  end
end
