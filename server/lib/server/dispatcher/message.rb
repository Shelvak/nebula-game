class Dispatcher::Message
  # Controller/Action splitter.
  SPLITTER = "|"

  attr_reader :id, :controller_name, :action, :params, :client, :player
  def pushed?; @pushed; end

  def initialize(id, action, params, client, player, pushed)
    @id = id
    @controller_name, @action = action.split(SPLITTER, 2)
    @params = params
    @client = client
    @player = player
    @pushed = pushed
  end

  def full_action
    "#{@controller_name}#{SPLITTER}#{@action}"
  end

  def to_s
    "<#{self.class} #{full_action}: id=#{@id} client=#{@client} player=#{@player
      } pushed=#{@pushed} params=#{@params.inspect}>"
  end
end