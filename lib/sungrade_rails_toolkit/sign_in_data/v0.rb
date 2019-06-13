module SungradeRailsToolkit
  module SignInData
    class V0
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end

      def sunnova_access_token
        data.fetch("sunnova", {}).fetch("access_token", nil)
      end
    end
  end
end
