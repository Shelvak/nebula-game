# Scala <-> Ruby interoperability.
module ScalaSupport
  class Hash
    include Enumerable

    def initialize(raw); @raw = raw; end
    def size; @raw.size; end
    def [](key); @raw.apply(key); end
    def []=(key, value); @raw.update(key, value); end
    def to_s; @raw.to_s; end
    def each; @raw.foreach { |tuple| yield tuple._1, tuple._2 }; end
  end

  class Set
    include Enumerable

    def initialize(raw); @raw = raw; end
    def size; @raw.size; end
    def to_s; @raw.to_s; end
    def each; @raw.foreach { |item| yield item }; end
  end

  class Array
    include Enumerable

    def initialize(raw); @raw = raw; end
    def size; @raw.size; end
    def [](key); @raw.apply(key); end
    def []=(key, value); @raw.update(key, value); end
    def to_s; @raw.to_s; end
    def each; @raw.foreach { |item| yield item }; end
  end

  class Tuple
    include Enumerable

    attr_reader :size

    def initialize(raw, size)
      @raw = raw
      @size = size
    end

    def [](index)
      index = @size + index if index < 0
      raise ArgumentError,
        "Index #{index} is out of bounds! (Max: #{@size - 1})" \
        if index > size - 1
      @raw.send(:"_#{index}")
    end

    def to_s; @raw.to_s; end
    def each; (0...@size).each { |index| self[index] }; end
  end
end

class Object
  def from_scala
    case self
    when Java::scala.collection.Map, Java::scala.collection.immutable.Map,
        Java::scala.collection.mutable.Map
      ScalaSupport::Hash.new(self)
    when Java::scala.collection.Set, Java::scala.collection.immutable.Set,
        Java::scala.collection.mutable.Set
      ScalaSupport::Set.new(self)
    when Java::scala.collection.Seq
      ScalaSupport::Array.new(self)
    when Java::scala.Product
      tuple = self.class.to_s.match(/Tuple(\d+)$/)
      if tuple
        ScalaSupport::Tuple.new(self, tuple[1].to_i)
      else
        self
      end
    else
      self
    end
  end
end

module Kernel
  def Some(value); Java::scala.Some.new(value); end
  None = Java::spacemule.helpers.JRuby.None

  def add_exception_info(exception, message)
    raise exception.class, message + "\n\n" + exception.message,
      exception.backtrace
  end
end