# Class that executes control commands via chat.
class Chat::Control
  # Player ID for system.
  SYSTEM_ID = 0
  # Player name for system.
  SYSTEM_NAME = "! System !"

  # Logging tag.
  TAG = "chat_control"

  def initialize(dispatcher, antiflood)
    @dispatcher = dispatcher
    @antiflood = antiflood
  end

  # Processes message as a command. Returns true if it was processed, false if
  # it is just a regular message.
  def message(player, message)
    return false unless player.chat_mod?

    command, args = message.split(" ", 2)
    args = args.nil? ? [] : self.class.parse_args(args)
    case command
    when "/help"
      cmd_help(player, args)
    when "/silence"
      cmd_silence(player, args)
    else
      return false # Report that this is not a command.
    end

    true
  end

  private

  def cmd_help(player, args)
    log(player, "help", args)
    command = args[0]
    case command
    when "silence"
      report(player.id,
        "/silence - silences player in chat for given time period",
        "",
        "Examples:",
        "    /silence 'bad player' 'for 30 minutes'",
        "    /silence \"bad player\" 'until 22:00'",
        "    /silence bad_player 'until 2012-01-01'"
      )
    else
      report(player.id,
        "Supported commands: silence",
        "",
        %Q{Message "/help command_name" for more information.},
        "",
        %Q{*** All commands only work in channels and private chat with "#{
          SYSTEM_NAME}" ***}
      )
    end
  end

  def cmd_silence(player, args)
    log(player, "silence", args)
    if args.size != 2
      report(player.id,
        "Wrong /silence argument count!",
        "Expected to get 2, got #{args.size}!",
        ""
      )
      cmd_help(player, ["silence"])
      return
    end

    name, time_str = args
    target = Player.
      where(:galaxy_id => player.galaxy_id, :name => name).
      first

    if target.nil?
      report(player.id, %Q{Cannot find player "#{name}" in galaxy #{
        player.galaxy_id}!})
      return
    end

    if target.chat_mod?
      report(player.id, %Q{Cannot silence another chat moderator!})
      return
    end

    time = Chronic.parse(time_str.sub(/^for /, 'in '))
    if time.nil?
      report(player.id, %Q{Cannot parse "#{time_str}" as a time!})
      return
    end

    if time <= Time.now
      report(player.id, %Q{Parsed time "#{time}" is in the past!})
      return
    end

    @antiflood.silence(target.id, time)
    report(player.id, %Q{Player "#{name}" silenced until "#{time}".})
  end

  def report(player_id, *messages)
    messages.each do |message|
      params = {'pid' => SYSTEM_ID, 'msg' => message, 'name' => SYSTEM_NAME}

      @dispatcher.transmit(
        {'action' => ChatController::PRIVATE_MESSAGE, 'params' => params},
        player_id
      )
    end
  end

  def log(player, command, args)
    LOGGER.info("#{player} invoked #{command} with #{args.inspect}", TAG)
  end

  # Parses line into arguments. Arguments can be quoted with single or double
  # quotes, however they do not support quotes within quotes. Arguments are
  # separated by spaces.
  def self.parse_args(line)
    # Magic of regexps...
    #
    # http://stackoverflow.com/questions/3243103/how-to-parse-a-quoted-search-string-using-regex
    line.scan(/'(.+?)'|"(.+?)"|([^ ]+)/).flatten.compact
  end
end
