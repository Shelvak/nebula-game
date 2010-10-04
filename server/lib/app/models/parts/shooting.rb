module Parts
  module Shooting
    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end

    module InstanceMethods
      def guns
        gun_index = -1
        @guns ||= (property('guns') || []).map do |data|
          gun_index += 1
          Gun.new(self, data, gun_index)
        end
      end

      def armor; property('armor'); end
      def evasiveness; property('evasiveness'); end
      def kind; property('kind'); end
      def ground?; kind == :ground; end
      def space?; kind == :space; end
    end
  end
end
