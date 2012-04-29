class Dispatcher::Message
  # Controller/Action splitter.
  SPLITTER = "|"

  # Message id.
  attr_reader :id
  # Message sequence number. Used to order messages in client.
  attr_reader :seq
  attr_reader :controller_name, :action, :params, :client, :player
  def pushed?; @pushed; end

  def initialize(id, seq, action, params, client, player, pushed)
    raise Dispatcher::NotAMessage, "id is nil!" if id.nil? && ! pushed
    @id = id
    @seq = seq
    raise Dispatcher::NotAMessage, "action is nil!" if action.nil?
    @controller_name, @action = action.split(SPLITTER, 2)
    raise Dispatcher::NotAMessage,
      "@action is nil! (action: #{action.inspect})" if @action.nil?
    @params = (params || {}).freeze
    @client = client
    @player = player
    @pushed = pushed
  end

  def full_action
    "#{@controller_name}#{SPLITTER}#{@action}"
  end

  def to_s
    "<#{self.class} #{full_action}: id=#{@id} seq=#{@seq || "nil"} client=#{
      @client} player=#{@player} pushed=#{@pushed} params=#{@params.inspect}>"
  end
end