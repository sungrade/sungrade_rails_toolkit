module SungradeRailsToolkit
  module ControllerHelpers
    def self.included(klass)
      klass.include(InstanceMethods)
      klass.extend(ClassMethods)
    end

    module InstanceMethods
      def require_user
        render json: "unauthorized", status: 401 unless SungradeRailsToolkit.store.current_user
      end
    end

    module ClassMethods
      def require_user(*args)
        -> (controller) {
          controller.render json: "unauthorized", status: 401 unless SungradeRailsToolkit.store.current_user
        }
      end
    end
  end
end
