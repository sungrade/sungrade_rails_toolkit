require "json"
require "jwt"

module SungradeRailsToolkit
  class Storage
    def current_user
      storage.fetch(:current_user) { nil }
    end

    def absolute_user
      storage.fetch(:absolute_user) { nil }
    end

    def request_id
      storage.fetch(:request_id) { nil }
    end

    def jwt
      storage.fetch(:jwt) { nil }
    end

    def serialize_from_env!(env)
      token = env.fetch(SungradeRailsToolkit.config.user_token_header) { nil }
      return unless token
      data = JSON.parse(
        JWT.decode(
          token, SungradeRailsToolkit.config.jwt_secret, true, { algorithm: SungradeRailsToolkit.config.jwt_algorithm }
        ).first["sub"]
      )
      redis_conn = Redis.new(SungradeRailsToolkit.config.auth_redis_params)

      write(:request_id, env.fetch("HTTP_X_REQUEST_ID", nil))
      current_user_identifier = data.fetch("current_user_identifier", nil)
      if current_user_identifier
        current_user = User.for_identifier(current_user_identifier)
        write(:current_user, current_user) if current_user
      end
      absolute_user_identifier = data.fetch("absolute_user_identifier", nil)
      if absolute_user_identifier
        absolute_user =  User.for_identifier(absolute_user_identifier)
        write(:absolute_user, absolute_user) if absolute_user
      end
      write(:jwt, token)
      data
    end

    # Hash methods
    def read(key)
      storage[key]
    end

    def [](key)
      storage[key]
    end

    def write(key, value)
      storage[key] = value
    end

    def []=(key, value)
      storage[key] = value
    end

    def exist?(key)
      storage.key?(key)
    end

    def fetch(key)
      storage[key] = yield unless exist?(key)
      storage[key]
    end

    def delete(key, &block)
      storage.delete(key, &block)
    end

    def storage
      @storage ||= {}
    end
  end
end
