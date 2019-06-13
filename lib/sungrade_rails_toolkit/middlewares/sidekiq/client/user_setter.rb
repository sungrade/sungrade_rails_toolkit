module SungradeRailsToolkit
  module Middlewares
    module Sidekiq
      module Client
        class UserSetter
          include ::SungradeRailsToolkit::Helpers
          def call(worker_class, job, queue, redis_pool)
            job['current_user_identifier'] ||= current_user&.identifier
            job['absolute_user_identifier'] ||= absolute_user&.identifier
            job['current_sign_in_identifier'] ||= current_sign_in&.identifier
            job['current_api_jwt'] ||= current_api_jwt
            yield
          end
        end
      end
    end
  end
end
