require "json"
require "sungrade_rails_toolkit/location/v0"

module SungradeRailsToolkit
  module Location
    class << self
      def v0
        Location::V0
      end
    end
  end
end
