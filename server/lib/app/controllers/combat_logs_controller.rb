class CombatLogsController < GenericController
  # Show combat log
  #
  # Invocation: by client
  #
  # Params:
  # - id (String): sha1 ID of the CombatLog
  #
  # Response:
  # - log (Hash): combat log as defined in Combat#run_combat
  #
  ACTION_SHOW = 'combat_logs|show'

  def invoke(action)
    case action
    when ACTION_SHOW
      param_options :required => %w{id}

      combat_log = CombatLog.find(params['id'])
      respond :log => combat_log.info
    end
  end
end