module SungradeRailsToolkit
  module UserRegion
    class V0
      attr_reader :data
      extend ApiRequestHelper

      def initialize(data)
        @data = data
      end

      def has_any_of_roles?(*role_values)
        roles.any? { |role| role.has_any_of_roles?(*role_values) }
      end

      def has_precise_roles?(*role_values)
        roles.any? { |role| role.is_precise_role?(*role_values) }
      end

      def roles
        @roles ||= data.fetch("roles").map { |role| UserRegionRole::V0.new(role) }
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
