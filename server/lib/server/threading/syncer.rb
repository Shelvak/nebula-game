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
    log "#{name} requested sync (#{count}) for token #{token}."
    until @tokens[token] == count
      wait token
      log "Sync token #{token} received, #{count - @tokens[token]
        } syncs remaining for #{name}."
    end
    @tokens.delete token
    log "Sync done for #{name} with token #{token}."
  end

  def sync(name, token)
    log "#{name} syncing in with token #{token}."
    @tokens[token] += 1
    signal token
  end
end