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
    param_options :required => {:id => String}

    combat_log = CombatLog.where(:sha1_id => params['id']).first
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find combat log with id #{params['id']}!"
    ) if combat_log.nil?
    respond :log => combat_log.info
  end
end