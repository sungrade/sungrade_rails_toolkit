module SungradeRailsToolkit
  module Middlewares
    module Sidekiq
      module Server
        class UserSetter
          include ::SungradeRailsToolkit::Helpers

          class << self
            def with_users!(job)
              begin
                set_users!(job)
                yield
                cleanup!
              rescue => ex
                cleanup!
                raise
              end
            end

            def cleanup!
              SungradeRailsToolkit.clear!
            end

            def set_users!(job)
              current_user_identifier = job["current_user_identifier"]
              absolute_user_identifier = job["absolute_user_identifier"]
              current_sign_in_identifier = job["current_sign_in_identifier"]
              current_api_jwt = job["current_api_jwt"]

              current_user = User.for_identifier(current_user_identifier)
              absolute_user =  User.for_identifier(absolute_user_identifier)
              current_sign_in =  SignInData.for_identifier(current_sign_in_identifier)
              ::SungradeRailsToolkit.store.write(:current_user, current_user) if current_user
              ::SungradeRailsToolkit.store.write(:absolute_user, absolute_user) if absolute_user
              ::SungradeRailsToolkit.store.write(:current_sign_in, current_sign_in) if current_sign_in
              ::SungradeRailsToolkit.store.write(:jwt, current_api_jwt) if current_api_jwt
            end
          end

          def call(worker, job, queue)
            self.class.with_users!(job) do
              yield
            end
          end
        end
      end
    end
  end
end
