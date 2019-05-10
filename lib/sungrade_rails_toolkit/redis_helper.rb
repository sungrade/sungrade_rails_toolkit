module SungradeRailsToolkit
  module RedisHelper
    def with_redis_connection
      redis_conn = Redis.new(SungradeRailsToolkit.config.auth_redis_params)
      yield(redis_conn)
    end
  end
end
