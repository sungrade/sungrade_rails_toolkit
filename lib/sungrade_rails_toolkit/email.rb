require "json"
require "sungrade_rails_toolkit/email/v0"

module SungradeRailsToolkit
  module Email
    class << self
      def v0
        Email::V0
      end
    end
  end
end
