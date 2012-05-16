module ScalaSupport
  class ImmutableException < StandardError; end

  module Common
    include Enumerable

    # Fake _target_ identity. This extends #is_a?, #kind_of?, #instance_of? on
    # _target_ and #=== on _pretended_klass_.
    #
    # Example: fake_identity YourCustomHash, Hash
    #
    # Beware that #<, #<= and #ancestors on _target_ will still return that
    # _target_ is not _pretended_klass_.
    #
    # @param [Class] target class that is being given fake identity
    # @param [Class] pretended_klass class that target is pretending to be
    def self.fake_identity(target, pretended_klass)
      target.instance_eval do
        [:is_a?, :kind_of?, :instance_of?].each do |method|
          define_method(method) do |klass|
            klass == pretended_klass ? true : super(klass)
          end
        end
      end

      (class << pretended_klass; self; end).instance_eval do
        define_method(:===) do |object|
          if object.is_a?(target)
            true
          else
            super(object)
          end
        end
      end
    end

    def initialize(raw)
      @raw = raw
    end

    def scala_collection
      @raw
    end

    def blank?
      @raw.isEmpty
    end

    def size
      @raw.size
    end
  end

  module Map
    module Common
      include ScalaSupport::Common

      def [](key)
        value = @raw.get(key)
        if value == None
          nil
        else
          value.get.from_scala
        end
      end

      def has_key?(key)
        @raw.contains(key)
      end

      def each
        if block_given?
          @raw.foreach do |tuple|
            yield tuple._1.from_scala, tuple._2.from_scala
          end
        else
          iterator = @raw.iterator

          Enumerator.new do |yielder|
            while iterator.hasNext
              tuple = iterator.next
              yielder << [tuple._1.from_scala, tuple._2.from_scala]
            end
          end
        end
      end

      def to_s
        first = true
        each_with_object("{") do |(key, value), str|
          first ? first = false : str << ", "
          str << "#{key}=>#{value}"
        end << "}"
      end

      def as_json(options=nil)
        each_with_object({}) do |(key, value), hash|
          hash[key.as_json(options)] = value.as_json(options)
        end
      end
    end

    class Immutable
      include Common
      ScalaSupport::Common.fake_identity self, Hash

      def []=(key, value)
        raise ImmutableException,
          "Cannot change #{key} on #{self} because it is immutable!"
      end
    end

    class Mutable
      include Common
      ScalaSupport::Common.fake_identity self, Hash

      def []=(key, value)
        @raw.update(key, value.to_scala)
      end
    end
  end

  module Seq
    module Common
      include ScalaSupport::Common

      def [](index)
        if index < 0
          @raw.apply(size + index).from_scala
        elsif index >= size
          nil
        else
          @raw.apply(index).from_scala
        end
      end

      def each
        if block_given?
          @raw.foreach do |item|
            yield item.from_scala
          end
        else
          iterator = @raw.iterator

          Enumerator.new do |yielder|
            yielder << iterator.next.from_scala while iterator.hasNext
          end
        end
      end

      def to_s
        first = true
        each_with_object("[") do |item, str|
          first ? first = false : str << ", "
          str << item.to_s
        end << "]"
      end
    end

    class Immutable
      include Common
      ScalaSupport::Common.fake_identity self, Array

      def []=(index, value)
        raise ImmutableException,
          "Cannot assign #{value} to index #{index} on #{self
          }: collection immutable"
      end
    end

    class Mutable
      include Common
      ScalaSupport::Common.fake_identity self, Array

      def []=(index, value)
        if index < 0
          @raw.update(size + index, value.to_scala)
        elsif index >= size
          (index - size + 1).times { @raw.send(:"+=", nil) }
          self[index] = value
        else
          @raw.update(index, value.to_scala)
        end
      end
    end
  end

  module Set
    module Common
      include ScalaSupport::Common

      def +(o)
        (@raw + o).from_scala
      end

      def -(o)
        (@raw - o).from_scala
      end

      def each
        if block_given?
          @raw.foreach { |item| yield item.from_scala }
        else
          Enumerator.new do |yielder|
            each { |item| yielder << item }
          end
        end
      end

      def to_s
        first = true
        each_with_object("#<Set: {") do |item, str|
          first ? first = false : str << ", "
          str << item.to_s
        end << "}>"
      end
    end

    class Immutable
      include Common
      ScalaSupport::Common.fake_identity self, Set

      def add(o)
        raise ImmutableException,
          "Cannot add #{o} to #{self}: immutable collection"
      end

      def delete(o)
        raise ImmutableException,
          "Cannot delete #{o} from #{self}: immutable collection"
      end
    end

    class Mutable
      include Common
      ScalaSupport::Common.fake_identity self, Set

      def add(o)
        @raw.send(:"+=", o.to_scala)
        self
      end

      def delete(o)
        @raw.send(:"-=", o.to_scala)
        self
      end
    end
  end

  class Tuple
    include Common
    Common.fake_identity self, Array

    def initialize(raw, size)
      super(raw)
      @size = size
    end

    def size
      @size
    end

    def blank?
      false
    end

    def each
      if block_given?
        (0...size).each do |index|
          yield self[index]
        end
        self
      else
        Enumerator.new do |yielder|
          self.each { |item| yielder << item }
        end
      end
    end

    def to_s
      first = true
      each_with_object("[") do |item, str|
        first ? first = false : str << ","
        str << item.to_s
      end << "]"
    end

    def [](index)
      if index < 0
        @raw.send("_#{size + index + 1}")
      elsif index >= size
        nil
      else
        @raw.send("_#{index + 1}")
      end
    end

    def []=(index, value)
      raise ImmutableException,
        "Cannot assign #{value} to index #{index} on #{self
        }: collection immutable"
    end
  end
end

# Scala <-> Ruby interoperability.
class Object
  def to_scala
    case self
    when ScalaSupport::Common
      self.scala_collection
    when Hash
      Java::jruby.MapWrapper.new(self)
    when Set
      Java::jruby.SetWrapper.new(self)
    when Array
      Java::jruby.ListWrapper.new(self)
    when Symbol
      Java::scala.Symbol.apply(to_s)
    else
      self.to_java
    end
  end

  def from_scala
    case self
    when Java::jruby.MapWrapper
      self.rubyHash
    when Java::scala.collection.mutable.Map
      ScalaSupport::Map::Mutable.new(self)
    when Java::scala.collection.Map, Java::scala.collection.immutable.Map
      ScalaSupport::Map::Immutable.new(self)
    when Java::Jruby.ListWrapper
      self.rubyArray
    when Java::scala.collection.mutable.Seq
      ScalaSupport::Seq::Mutable.new(self)
    when Java::scala.collection.Seq, Java::scala.collection.immutable.Seq
      ScalaSupport::Seq::Immutable.new(self)
    when Java::scala.Product
      match = self.class.to_s.match(/^Java::Scala::Tuple(\d+)$/)
      if match
        size = match[1].to_i
        ScalaSupport::Tuple.new(self, size)
      else
        self
      end
    when Java::jruby.SetWrapper
      self.rubySet
    when Java::scala.collection.mutable.Set
      ScalaSupport::Set::Mutable.new(self)
    when Java::scala.collection.Set, Java::scala.collection.immutable.Set,
      ScalaSupport::Set::Immutable.new(self)
    else
      self
    end
  end
end

module Kernel
  def Some(value); Java::scala.Some.new(value); end
  None = Java::jruby.JRuby.None

  def add_exception_info(exception, message)
    raise exception.class, message + "\n\n" + exception.message,
      exception.backtrace
  end
end