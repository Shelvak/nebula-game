class Threading::Syncer
  include NamedLogMessages
  include Celluloid

  def initialize(name)
    @name = name
    @tokens = Hash.new(0)
  end

  def to_s
    "syncer-#{@name}"
  end

  def request_sync(name, count, token)
    info "#{name} requested sync (#{count}) for token #{token}."
    until @tokens[token] == count
      wait token
      info "Sync token #{token} received, #{count - @tokens[token]
        } syncs remaining for #{name}."
    end
    @tokens.delete token
    info "Sync done for #{name} with token #{token}."
  end

  def sync(name, token)
    info "#{name} syncing in with token #{token}."
    @tokens[token] += 1
    signal token
  end
end