class GenericController::ParamOpts
  class BadParams < ArgumentError; end

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.required(hash); new(:required => hash); end
  def self.valid(list); new(:valid => list); end
  def self.only_push; new(:only_push => true); end

  def +(param_opts)
    new(@data.merge(param_opts.data))
  end

  def check!(message)
    raise BadParams.new(
      "Expected message #{message.full_action} to be pushed, but it was not!"
    ) if @data[:only_push] && ! message.pushed?

    begin
      message.params.ensure_options!(
        :required => @data[:required], :valid => @data[:valid]
      )
    rescue ArgumentError => e
      raise BadParams, "Bad parameters in #{message.full_action}! #{e.message}",
        e.backtrace
    end
  end
end