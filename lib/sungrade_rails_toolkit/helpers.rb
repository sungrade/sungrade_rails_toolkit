module SungradeRailsToolkit
  module Helpers
    def current_user
      SungradeRailsToolkit.store.current_user
    end

    def absolute_user
      SungradeRailsToolkit.store.absolute_user
    end

    def current_sign_in
      SungradeRailsToolkit.store.current_sign_in
    end

    def current_api_jwt
      SungradeRailsToolkit.store.jwt
    end
  end
end
