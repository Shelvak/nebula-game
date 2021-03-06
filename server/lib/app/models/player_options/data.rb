class PlayerOptions::Data < OptionsHash
  ### Chat options ###

  # Should chat join/leave messages be shown?
  property :chat_show_join_leave, default: false, valid: Boolean

  # Ignored player chat messages are not shown at all.
  CHAT_IGNORE_COMPLETE = "complete"
  # Ignored player chat messages are shown with text filtered out, like this:
  # <ignored_player> [you are ignoring this user]
  CHAT_IGNORE_FILTERED = "filtered"

  CHAT_IGNORE_TYPES = [CHAT_IGNORE_COMPLETE, CHAT_IGNORE_FILTERED]

  # What kind of chat ignore player uses.
  property :chat_ignore_type, default: CHAT_IGNORE_COMPLETE,
    valid: lambda { |val| CHAT_IGNORE_TYPES.include?(val) }

  # Array of player names which are ignored by this player.
  property :ignored_chat_players, default: [], valid: lambda { |val|
    val.is_a?(Array) && val.each { |v| v.is_a?(String) }
  }

  ### After-login options ###

  # Should daily bonus/quest/announcement popups be opened upon login if they
  # are present?
  property :show_popups_after_login, default: true, valid: Boolean

  # Should first planet be opened after login?
  property :open_first_planet_after_login, default: true, valid: Boolean

  ### Graphics options ###

  # Show animations on planet terrain.
  property :enable_planet_animations, default: true, valid: Boolean

  ### Generic options ###

  # Should game warn player before navigating away from page?
  property :warn_before_unload, default: true, valid: Boolean

  # Should we show metadata icons on wormholes?
  property :show_wormhole_icons, default: true, valid: Boolean

  # Time to show fault/success events.
  property :action_event_time, default: 5, valid: lambda { |val|
    (1..30).cover?(val)
  }

  # Time to show notification events.
  property :notification_event_time, default: 3, valid: lambda { |val|
    (1..30).cover?(val)
  }

  # Should we show info events?
  property :show_info_events, default: true, valid: Boolean

  TRANSPORTER_TAB_RESOURCES = 0
  TRANSPORTER_TAB_UNITS = 1

  TRANSPORTER_TABS = [TRANSPORTER_TAB_RESOURCES, TRANSPORTER_TAB_UNITS]

  # Which tab should be opened first when opening a transporter
  property :default_transporter_tab, default: TRANSPORTER_TAB_RESOURCES,
    valid: lambda { |val| TRANSPORTER_TABS.include?(val) }

  TECH_SORT_TYPE_SCIENTISTS = 0
  TECH_SORT_TYPE_TIME = 1

  TECH_SORT_TYPES = [TECH_SORT_TYPE_SCIENTISTS, TECH_SORT_TYPE_TIME]

  # Which property should technologies by sorted by in technology sidebar
  property :technologies_sort_type, default: TECH_SORT_TYPE_SCIENTISTS,
    valid: lambda { |val| TECH_SORT_TYPES.include?(val) }

  # Which sound should we play when notification is received?
  property :sound_for_notification, default: "n00", valid: String

  # Which sound should we play when alliance message is received?
  property :sound_for_alliance_msg, default: "c00", valid: String

  # Which sound should we play when private message is received?
  property :sound_for_private_msg, default: "c01", valid: String
end