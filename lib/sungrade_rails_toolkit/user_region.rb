require "json"
require "sungrade_rails_toolkit/user_region/v0"

module SungradeRailsToolkit
  module UserRegion
    class << self
      def v0
        UserRegion::V0
      end
    end
  end
end
