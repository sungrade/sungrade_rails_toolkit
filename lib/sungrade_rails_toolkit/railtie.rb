module SungradeRailsToolkit
  class Railtie < ::Rails::Railtie
    initializer "sungrade_rails_toolkit.insert_middleware" do |app|
      if ActionDispatch.const_defined? :RequestId
        app.config.middleware.insert_after ActionDispatch::RequestId, SungradeRailsToolkit::Middleware
      else
        app.config.middleware.insert_after Rack::MethodOverride, SungradeRailsToolkit::Middleware
      end

      if ActiveSupport.const_defined?(:Reloader) && ActiveSupport::Reloader.respond_to?(:to_complete)
        ActiveSupport::Reloader.to_complete do
          SungradeRailsToolkit.clear!
        end
      elsif ActionDispatch.const_defined?(:Reloader) && ActionDispatch::Reloader.respond_to?(:to_cleanup)
        ActionDispatch::Reloader.to_cleanup do
          SungradeRailsToolkit.clear!
        end
      end
    end
  end
end
