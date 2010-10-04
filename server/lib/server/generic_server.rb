# Just to store various constants.
module GenericServer
  # If the client message was an empty string.
  REASON_EMPTY_MESSAGE = "empty_message"
  # If we couldn't parse client message as JSON.
  REASON_JSON_ERROR = "json_error"
  # If something failed in the server code.
  REASON_SERVER_ERROR = "server_error"
  # If client required something that server didn't find logical.
  REASON_GAME_ERROR = "game_error"
  # If control authentication token did not match.
  REASON_AUTH_ERROR = "auth_error"
end
