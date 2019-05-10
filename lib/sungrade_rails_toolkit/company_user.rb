require "json"
require "sungrade_rails_toolkit/company_user/v0"

module SungradeRailsToolkit
  module CompanyUser
    class << self
      def v0
        CompanyUser::V0
      end
    end
  end
end
