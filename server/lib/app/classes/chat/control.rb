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
    return false unless player.admin? || player.chat_mod?

    command, args = message.split(" ", 2)
    args = args.nil? ? [] : self.class.parse_args(args)

    # Admin-only commands
    admin_commands = lambda do
      case command
      when "/adminify" then cmd_adminify(player, args)
      when "/set_mod" then cmd_set_mod(player, args)
      else return false
      end

      true
    end

    # Regular commands.
    regular_commands = lambda do
      case command
      when "/help" then cmd_help(player, args)
      when "/silence" then cmd_silence(player, args)
      else return false
      end

      true
    end

    if player.admin?
      admin_commands.call || regular_commands.call
    else
      regular_commands.call
    end
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
    when "adminify"
      report(player.id,
        "/adminify - makes player a galaxy administrator",
        "",
        "WARNING: THERE IS NO WAY DO DE-ADMINIFY PLAYER FROM CHAT AFTER THIS!",
        "",
        "Examples:",
        "    /adminify 'player name'"
      )
    when "set_mod"
      report(player.id,
        "/set_mod - sets if player is a chat moderator",
        "",
        "Examples:",
        "    /set_mod 'player name' true",
        "    /set_mod 'player name' false"
      )
    else
      report(player.id, "Supported commands: silence")
      report(player.id, "Supported admin commands: adminify set_mod") \
        if player.admin?
      report(player.id,
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
    check_args(player, args, 2) or return

    name, time_str = args
    target = find_player(player, name) or return

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

  def cmd_adminify(player, args)
    log(player, "adminify", args)
    check_args(player, args, 1) or return

    name = args[0]
    target = find_player(player, name) or return

    target.admin = true
    target.save!
    report(player.id, %Q{Player "#{name}" is now galaxy administrator.})
  end

  def cmd_set_mod(player, args)
    log(player, "adminify", args)
    check_args(player, args, 2) or return

    name, value = args
    target = find_player(player, name) or return
    value = case value
    when "true" then true
    when "false" then false
    else
      report(player.id, "Unknown second parameter: #{value.inspect}!")
      return
    end

    target.chat_mod = value
    target.save!
    msg = value \
      ? "has been made a chat moderator." \
      : "is not longer a chat moderator."
    report(player.id, %Q{Player "#{name}" #{msg}})
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

  def find_player(player, name)
    target = Player.where(:galaxy_id => player.galaxy_id, :name => name).first
    if target.nil?
      report(player.id,
        %Q{Cannot find player by "#{name}" in galaxy #{player.galaxy_id}!})
      return false
    end

    target
  end

  def check_args(player, args, arity)
    if args.size != arity
      report(player.id,
        "Wrong argument count! Expected to get #{arity}, got #{args.size}!"
      )
      false
    else
      true
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
