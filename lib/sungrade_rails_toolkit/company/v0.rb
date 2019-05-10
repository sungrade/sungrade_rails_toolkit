module SungradeRailsToolkit
  module Company
    class V0
      attr_reader :data, :from_user
      extend ApiRequestHelper

      class << self
        def find_or_create(params)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/companies/find_or_create"),
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
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/companies/#{identifier}"),
          )
          new(JSON.parse(res.body))
        end

        def search(params)
          body = params.is_a?(String) ? params : params.to_json
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/companies/search"),
            headers: {"Content-Type" => "application/json"},
            body: body
          )
          JSON.parse(res.body).map { |user| new(user) }
        end
      end

      def initialize(data, from_user: false)
        @data = data
        @from_user = from_user
      end

      def offices
        @offices ||= [
          primary_office,
          *additional_offices
        ]
      end

      def primary_office
        @primary_office ||= office_klass.new(
          data.fetch("offices", {}).fetch("primary")
        )
      end

      def additional_offices
        @additional_offices ||= data.fetch("offices", {}).fetch("additional", []).map do |data|
          office_klass.new(data)
        end
      end

      def office_klass
        if from_user
          UserOffice::V0
        else
          Office::V0
        end
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
