module SungradeRailsToolkit
  module UserOffice
    class V0
      attr_reader :data
      extend ApiRequestHelper
      include ApiRequestHelper

      def initialize(data)
        @data = data
      end

      def identifier
        office.identifier
      end

      def office
        Office::V0.new(data.fetch("office"))
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
