module SungradeRailsToolkit
  module WorkflowRole
    class V0
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def has_any_of_roles?(*roles)
        return true if roles.include?(name) || roles.include?(value)
        children.any? { |role| role.has_any_of_roles?(*roles) }
      end

      def is_precise_role?(*roles)
        roles.include?(name) || roles.include?(value)
      end

      def children
        @children ||= data.fetch("children").map { |child| self.class.new(child) }
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
