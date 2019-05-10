module SungradeRailsToolkit
  class Configuration
    attr_accessor :jwt_secret, :jwt_algorithm
    attr_accessor :user_token_header
    attr_accessor :user_version, :office_version
    attr_accessor :api_gateway_base_url, :api_gateway_token
    attr_accessor :auth_redis_params

    class << self
      def instance
        @instance ||= new
      end

      def evaluate(blk)
        instance.instance_eval(&blk)
      end
    end

    def user_klass
      User.current_klass
    end
  end
end
