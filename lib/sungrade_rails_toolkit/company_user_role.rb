require "json"
require "sungrade_rails_toolkit/company_user_role/v0"

module SungradeRailsToolkit
  module CompanyUserRole
    class << self
      def v0
        CompanyUserRole::V0
      end
    end
  end
end
