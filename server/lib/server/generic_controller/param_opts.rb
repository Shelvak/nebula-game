class GenericController::ParamOpts
  class BadParams < ArgumentError; end

  attr_reader :data

  def initialize(data)
    @data = data.freeze
  end

  def self.required(hash); new(:required => hash.stringify_keys); end
  def self.valid(list); new(:valid => list.map(&:to_s)); end
  def self.only_push; new(:only_push => true); end
  def self.logged_in; new(:logged_in => true); end
  def self.control_token
    new(:required => {'control_token' => String}, :control_token => true)
  end
  def self.no_options; new({}); end

  # Returns new +ParamOpts+ representing sum of two +ParamOpts+.
  def +(param_opts)
    merged = @data[:required].merge(param_opts.data[:required])

    # Merge :required and :valid instead of overwriting.
    if @data[:required] && param_opts.data[:required]
      merged[:required] = @data[:required].merge(param_opts.data[:required])
    end
    if @data[:valid] && param_opts.data[:valid]
      merged[:valid] = @data[:valid] | param_opts.data[:valid]
    end

    self.class.new(merged)
  end

  def check!(message)
    raise BadParams.new(
      "Expected #{message} to be pushed, but it was not!"
    ) if @data[:only_push] && ! message.pushed?
    raise BadParams.new(
      "Expected #{message} to be from logged in player, but it was not!"
    ) if @data[:logged_in] && message.player.nil?
    raise BadParams.new(
      "Expected #{message} to have control token, but it did not or it " +
      "was invalid!"
    ) if @data[:control_token] && message.params['token'] != Cfg.control_token

    begin
      message.params.ensure_options!(
        :required => @data[:required], :valid => @data[:valid]
      )
    rescue ArgumentError => e
      raise BadParams, "Bad parameters in #{message}! #{e.message}",
        e.backtrace
    end
  end
end