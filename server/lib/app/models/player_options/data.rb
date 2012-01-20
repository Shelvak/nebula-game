class PlayerOptions::Data < OptionsHash
  ### Chat options ###

  # Should chat join/leave messages be shown?
  property :chat_show_join_leave, :default => false, :valid => Boolean

  # Ignored player chat messages are not shown at all.
  CHAT_IGNORE_COMPLETE = "complete"
  # Ignored player chat messages are shown with text filtered out, like this:
  # <ignored_player> [you are ignoring this user]
  CHAT_IGNORE_FILTERED = "filtered"

  CHAT_IGNORE_TYPES = [CHAT_IGNORE_COMPLETE, CHAT_IGNORE_FILTERED]

  # What kind of chat ignore player uses.
  property :chat_ignore_type, :default => CHAT_IGNORE_COMPLETE,
    :valid => lambda { |val| CHAT_IGNORE_TYPES.include?(val) }

  # Array of player names which are ignored by this player.
  property :ignored_chat_players, :default => [], :valid => lambda { |val|
    val.is_a?(Array) && val.each { |v| v.is_a?(String) }
  }

  ### After-login options ###

  # Should daily bonus/quest/announcement popups be opened upon login if they
  # are present?
  property :show_popups_after_login, :default => true, :valid => Boolean

  # Should first planet be opened after login if player only has one planet?
  property :open_only_planet_after_login, :default => true, :valid => Boolean

  ### Generic options ###

  # Should game warn player before navigating away from page?
  property :warn_before_unload, :default => true, :valid => Boolean
end