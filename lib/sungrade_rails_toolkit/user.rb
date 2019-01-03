require "json"
require "sungrade_rails_toolkit/user/v0"

module SungradeRailsToolkit
  module User
    class << self
      def serialize(data)
        version = SungradeRailsToolkit.config.user_version.to_s
        if version.downcase == "v0"
          current_klass.new(data.fetch("v0"))
        end
      end

      def current_klass
        version = SungradeRailsToolkit.config.user_version.to_s
        if version.downcase == "v0"
          v0
        end
      end

      def v0
        User::V0
      end
    end
  end
end
