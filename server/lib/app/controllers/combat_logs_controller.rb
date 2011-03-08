class CombatLogsController < GenericController
  ACTION_SHOW = 'combat_logs|show'
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
  def action_show
    param_options :required => %w{id}

    combat_log = CombatLog.find(params['id'])
    respond :log => combat_log.info.as_json
  end
end