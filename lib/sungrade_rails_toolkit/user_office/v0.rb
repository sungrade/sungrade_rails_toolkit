module SungradeRailsToolkit
  module UserOffice
    class V0
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def identifier
        office.identifier
      end

      def regions
        office.regions
      end

      def office
        @office ||= Office::V0.new(data.fetch("office"))
      end

      def method_missing(meth, *args, &blk)
        data.fetch(meth.to_s) { super }
      end
    end
  end
end
