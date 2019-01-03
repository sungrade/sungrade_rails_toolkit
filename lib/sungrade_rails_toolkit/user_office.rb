require "json"
require "sungrade_rails_toolkit/user_office/v0"

module SungradeRailsToolkit
  module UserOffice
    class << self
      def v0
        Office::V0
      end
    end
  end
end
