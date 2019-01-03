module SungradeRailsToolkit
  module Helpers
    def current_user
      SungradeRailsToolkit.store.current_user
    end

    def absolute_user
      SungradeRailsToolkit.store.absolute_user
    end
  end
end
