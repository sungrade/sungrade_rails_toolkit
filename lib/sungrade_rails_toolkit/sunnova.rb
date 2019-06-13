require "json"
require "sungrade_rails_toolkit/sunnova/v0"

module SungradeRailsToolkit
  module Sunnova
    class << self
      def v0
        Sunnova::V0
      end
    end
  end
end
