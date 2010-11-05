module Parts
  module Shooting
    KIND_GROUND = :ground
    KIND_SPACE = :space

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
      def ground?; kind == KIND_GROUND; end
      def space?; kind == KIND_SPACE; end
    end
  end
end
