class GenericController::ParamOpts
  class BadParams < ArgumentError; end

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.required(hash); new(:required => hash.stringify_keys); end
  def self.valid(list); new(:valid => list.map(&:to_s)); end
  def self.only_push; new(:only_push => true); end
  def self.logged_in; new(:logged_in => true); end
  def self.control_token; new(:control_token => true); end
  def self.no_options; new({}); end

  # Returns new +ParamOpts+ representing sum of two +ParamOpts+.
  def +(param_opts)
    self.class.new(@data.merge(param_opts.data))
  end

  def check!(message)
    raise BadParams.new(
      "Expected #{message} to be pushed, but it was not!"
    ) if @data[:only_push] && ! message.pushed?
    raise BadParams.new(
      "Expected #{message} to be from logged in player, but it was not!"
    ) if @data[:logged_in] && message.player.nil?
    raise BadParams.new(
      "Expected #{message
        } to have control token, but it did not or it was invalid!"
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