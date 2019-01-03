require "json"
require "sungrade_rails_toolkit/office/v0"

module SungradeRailsToolkit
  module Office
    class << self
      def v0
        Office::V0
      end
    end
  end
end
