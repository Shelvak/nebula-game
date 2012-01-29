# Usage:
#   class DataHolder < OptionsHash
#     # Should game warn player before navigating away from page?
#     property :warn_before_unload, :default => true, :valid => Boolean
#     # What kind of chat ignore player uses.
#     property :chat_ignore_type, :default => "complete",
#       :valid => lambda { |val| ["complete", "filtered"].include?(val) }
#     # Array of player names which are ignored by this player.
#     property :ignored_chat_players, :default => [],
#       :valid => lambda { |val|
#         val.is_a?(Array) && val.each { |v| v.is_a?(String) }
#       }
#   end
#
#  >> d = DataHolder.new
#  => #<DataHolder:0x7a811c @data={:warn_before_unload=>true, :chat_ignore_type=>"complete", :ignored_chat_players=>[]}>
#  >> d.warn_before_unload = false
#  => false
#  >> d
#  => #<DataHolder:0x7a811c @data={:warn_before_unload=>false, :chat_ignore_type=>"complete", :ignored_chat_players=>[]}>
#  >> d.warn_before_unload?
#  => false
#
class OptionsHash
  def initialize(data={})
    @data = self.class.defaults.merge(data.symbolize_keys)
  end

  def as_json(options=nil)
    @data
  end

  def to_s
    "<#{self.class} #{@data.inspect}>"
  end

  def ==(other); eql?(other); end
  def eql?(other); other.is_a?(self.class) && as_json == other.as_json; end

  class << self
    def defaults
      @defaults.each_with_object({}) do |(name, default), hash|
        hash[name] = default.duplicable? ? default.dup : default
      end
    end

    def properties; @properties.dup; end

    def getters; @getters.dup; end

    protected

    def property(name, options={})
      typesig binding, Symbol, Hash
      options.assert_valid_keys :default, :valid

      @properties ||= Set.new
      @properties.add name

      @defaults ||= {}
      @defaults[name] = options[:default] if options.has_key?(:default)

      # Getter
      getter_name = options[:valid] == Boolean ? "#{name}?" : name
      define_method(getter_name) { @data[name] }

      @getters ||= Set.new
      @getters.add getter_name

      # Setter
      define_method("#{name}=") do |value|
        case options[:valid]
        when Proc
          raise ArgumentError.new(
            "Value #{value.inspect} for property #{name} is invalid!"
          ) unless options[:valid].call(value)
        else
          typesig_bindless [[name, value]], options[:valid]
        end if options.has_key?(:valid)

        @data[name] = value
      end
    end
  end
end