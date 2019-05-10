require "json"
require "sungrade_rails_toolkit/region/v0"

module SungradeRailsToolkit
  module Region
    class << self
      def v0
        Region::V0
      end
    end
  end
end
