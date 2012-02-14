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

  def self.show_options; required(:id => String); end
  def self.show_scope(m); scope.server; end
  def self.show_action(m)
    combat_log = CombatLog.where(:sha1_id => m.params['id']).first
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find combat log with id #{m.params['id']}!"
    ) if combat_log.nil?
    respond m, :log => combat_log.info
  end
end