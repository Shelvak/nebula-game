class GenericController::ParamOpts
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
end