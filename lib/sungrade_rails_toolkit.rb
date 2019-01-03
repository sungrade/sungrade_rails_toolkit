require "sungrade_rails_toolkit/version"
require "sungrade_rails_toolkit/error"
require "sungrade_rails_toolkit/middleware"
require "sungrade_rails_toolkit/storage"
require "sungrade_rails_toolkit/api_request_helper"
require "sungrade_rails_toolkit/configuration"
require "sungrade_rails_toolkit/user"
require "sungrade_rails_toolkit/user_office"
require "sungrade_rails_toolkit/office"
require "sungrade_rails_toolkit/location"
require "sungrade_rails_toolkit/helpers"
require "sungrade_rails_toolkit/token"
require "sungrade_rails_toolkit/railtie" if defined?(Rails::Railtie)

module SungradeRailsToolkit
  class << self
    def store
      Thread.current[:sungrade_store] ||= Storage.new
    end

    def clear!
      Thread.current[:sungrade_store] = nil
    end

    def begin!
      Thread.current[:sungrade_store_active] = true
    end

    def end!
      Thread.current[:sungrade_store_active] = false
    end

    def serialize_from_env!(env)
      store.serialize_from_env!(env)
    end

    def configure(&blk)
      Configuration.evaluate(blk)
    end

    def config
      Configuration.instance
    end
  end
end
