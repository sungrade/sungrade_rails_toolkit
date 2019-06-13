require "json"
require "sungrade_rails_toolkit/sign_in_data/v0"
require "sungrade_rails_toolkit/redis_helper"

module SungradeRailsToolkit
  module SignInData
    attr_reader :data

    class << self
      include RedisHelper

      def serialize(data)
        V0.new(data.fetch("v0"))
      end

      def for_identifier(identifier)
        data = with_redis_connection do |conn|
          conn.get(generate_redis_key(identifier))
        end
        return unless data
        serialize(JSON.parse(data))
      end

      def generate_redis_key(id)
        "user_sign_ins:#{id}"
      end
    end
  end
end
