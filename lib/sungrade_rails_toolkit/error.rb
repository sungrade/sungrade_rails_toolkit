module SungradeRailsToolkit
  class Err < StandardError; end
  class UnsuccessfulResponse < Err
    attr_reader :response

    def initialize(response:)
      @response = response
      super("#{response.status} #{response.body}")
    end
  end
end
