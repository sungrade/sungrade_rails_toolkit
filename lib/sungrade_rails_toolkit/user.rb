require "json"
require "sungrade_rails_toolkit/user/v0"
require "sungrade_rails_toolkit/redis_helper"

module SungradeRailsToolkit
  module User
    class << self
      include RedisHelper

      def serialize(data)
        version = SungradeRailsToolkit.config.user_version.to_s
        if version.downcase == "v0"
          v0.new(data.fetch("v0"))
        end
      end

      def current_klass
        version = SungradeRailsToolkit.config.user_version.to_s
        if version.downcase == "v0"
          v0
        end
      end

      def for_identifiers(*identifiers)
        return [] unless identifiers&.any?
        identifiers = identifiers.uniq.reject(&:blank?)
        identifiers = identifiers.map { |id| generate_redis_key(id) }
        with_redis_connection { |conn| conn.mget(identifiers) }.compact.map do |data|
          serialize(JSON.parse(data))
        end
      end

      def for_identifier(identifier)
        data = with_redis_connection do |conn|
          conn.get(generate_redis_key(identifier))
        end
        return unless data
        serialize(JSON.parse(data))
      end

      def generate_redis_key(id)
        "users:#{id}"
      end

      def v0
        User::V0
      end
    end
  end
end
