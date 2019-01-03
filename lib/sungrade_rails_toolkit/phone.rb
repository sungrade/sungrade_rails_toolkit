require "json"
require "sungrade_rails_toolkit/phone/v0"

module SungradeRailsToolkit
  module Phone
    class << self
      def v0
        Phone::V0
      end
    end
  end
end
