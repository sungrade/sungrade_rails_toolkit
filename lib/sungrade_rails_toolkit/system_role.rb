require "json"
require "sungrade_rails_toolkit/system_role/v0"

module SungradeRailsToolkit
  module SystemRole
    class << self
      def v0
        SystemRole::V0
      end
    end
  end
end
