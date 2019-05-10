require "json"
require "sungrade_rails_toolkit/user_region_role/v0"

module SungradeRailsToolkit
  module UserRegionRole
    class << self
      def v0
        UserRegionRole::V0
      end
    end
  end
end
