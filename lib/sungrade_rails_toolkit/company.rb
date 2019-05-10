require "json"
require "sungrade_rails_toolkit/company/v0"

module SungradeRailsToolkit
  module Company
    class << self
      def v0
        Company::V0
      end
    end
  end
end
