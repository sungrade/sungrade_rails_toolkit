require "json"
require "sungrade_rails_toolkit/workflow_role/v0"

module SungradeRailsToolkit
  module WorkflowRole
    class << self
      def v0
        WorkflowRole::V0
      end
    end
  end
end
