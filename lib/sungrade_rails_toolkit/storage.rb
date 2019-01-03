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

    def user_token
      storage.fetch(:user_token) { nil }
    end

    def serialize_from_env!(env)
      token = env.fetch(SungradeRailsToolkit.config.user_token_header) { nil }
      return unless token
      data = JSON.parse(
        JWT.decode(
          token, SungradeRailsToolkit.config.jwt_secret, true, { algorithm: SungradeRailsToolkit.config.jwt_algorithm }
        ).first["sub"]
      )

      write(:request_id, env.fetch("HTTP_X_REQUEST_ID", nil))
      write(:current_user, User.serialize(data.fetch("current_user")))
      write(:absolute_user, User.serialize(data.fetch("absolute_user")))
      write(:jwt, token)
      write(:user_token, data.fetch("user_token"))
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
