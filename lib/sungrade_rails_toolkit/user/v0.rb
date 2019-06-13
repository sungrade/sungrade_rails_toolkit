module SungradeRailsToolkit
  module User
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      class << self
        def find_or_create(params)
          body = params.is_a?(String) ? params : params.to_json
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/users/find_or_create"),
            body: body,
            headers: {"Content-Type" => "application/json"}
          )
          new(JSON.parse(res.body))
        end

        def for_identifiers(*identifiers)
          search(params: {identifiers: identifiers})
        end

        def search(params:)
          body = params.is_a?(String) ? params : params.to_json
          res = put(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/users/search"),
            headers: {"Content-Type" => "application/json"},
            body: body
          )

          identifiers = JSON.parse(res.body)["identifiers"]
          SungradeRailsToolkit::User.for_identifiers(*identifiers)
        end

        def for_identifier(identifier)
          res = get(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/users/#{identifier}"),
          )
          new(JSON.parse(res.body))
        end

        def for_legacy_ids(*ids)
          res = post(
            url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/users/for_legacy_ids"),
            body: {
              ids: ids.compact
            }.to_json,
            headers: {"Content-Type" => "application/json"}
          )
          JSON.parse(res.body).map { |user| new(user) }
        end
      end

      def initialize(data)
        @data = data
      end

      def full_name
        [
          first_name,
          last_name
        ].compact.join(" ")
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end

      def offices
        @offices ||= companies.map(&:offices).flatten.compact
      end

      def office_identifiers
        offices.map(&:identifier)
      end

      def primary_office
        @primary_office ||= primary_company&.primary_office
      end

      def companies
        [
          primary_company,
          *additional_companies
        ].flatten.compact
      end

      def company_identifiers
        companies.map(&:identifier)
      end

      def primary_company
        @primary_company ||= begin
          company_user_data = data.fetch("companies", {}).fetch("primary")
          CompanyUser::V0.new(company_user_data) if company_user_data
        end
      end

      def primary_email
        @primary_email ||= begin
          email_data = data.fetch("emails", {}).fetch("primary")
          Email::V0.new(email_data) if email_data
        end
      end

      def primary_phone
        @primary_phone ||= begin
          phone_data = data.fetch("phones", {}).fetch("primary")
          Phone::V0.new(phone_data) if phone_data
        end
      end

      def has_precise_company_roles?(*roles)
        companies.any? { |company| company.has_precise_role?(role) }
      end

      def has_precise_company_roles?(role)
        has_precise_company_roles?(role)
      end

      def has_any_of_company_roles?(*roles)
        companies.any? { |company| company.has_any_of_roles?(*roles) }
      end

      def has_company_role?(role)
        has_any_of_company_roles?(role)
      end

      def has_any_of_region_roles?(*roles)
        regions.any? { |region| region.has_any_of_roles?(*roles) }
      end

      def has_region_role?(role)
        has_any_of_region_roles?(role)
      end

      def system_roles
        @system_roles ||= data.fetch("roles", {}).fetch("system", []).map do |system_role_data|
          SystemRole::V0.new(system_role_data)
        end
      end

      def has_system_role?(role)
        has_system_roles?(role)
      end

      def has_system_roles?(*roles)
        system_roles.any? { |system_role| system_role.has_any_of_roles?(*roles) }
      end

      def workflow_roles
        @workflow_roles ||= data.fetch("roles", {}).fetch("workflow", []).map do |workflow_role_data|
          WorkflowRole::V0.new(workflow_role_data)
        end
      end

      def has_workflow_role?(role)
        has_workflow_roles?(role)
      end

      def has_workflow_roles?(*roles)
        workflow_roles.any? { |workflow_role| workflow_role.has_any_of_roles?(*roles) }
      end

      def regions
        @regions ||= data.fetch("regions", []).map { |user_region| UserRegion::V0.new(user_region) }
      end

      def additional_companies
        @additional_companies ||= data.fetch("companies", {}).fetch("additional", []).map { |company_user| CompanyUser::V0.new(company_user) }
      end

      def update(params)
        body = params.is_a?(String) ? params : params.to_json
        res = post(
          url: File.join(SungradeRailsToolkit.config.api_gateway_base_url, "/internal_api/v0/users/#{identifier}"),
          headers: {"Content-Type" => "application/json"},
          body: body
        )
        set_body!(JSON.parse(res.body))
      end

      def set_body!(data)
        if data.fetch("identifier") == identifier
          @data = data
          @primary_office = nil
          @additional_offices = nil
          @primary_company = nil
          @additional_companies = nil
          self
        else
          self.class.new(data)
        end
      end
    end
  end
end
