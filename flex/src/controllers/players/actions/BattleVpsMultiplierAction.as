package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;

   import models.movement.MSquadKillReward;

   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;

   /**
    *
    # Returns multiplier for battle victory points when fighting against
    # targeted player.
    #
    # Invocation: by client
    #
    # Parameters:
    # - target_id (Fixnum): player id that you are targeting.
    #
    # Response:
    # - multiplier (Float): multiplier between [0, inf) for victory points. This
    # multiplier can be inserted into 'battleground.battle.victory_points' or
    # 'combat.battle.victory_points' config formulas as 'fairness_multiplier'
    # parameter.
    #
    *
    * @author Jho
    *
    */
   public class BattleVpsMultiplierAction extends CommunicationAction
   {

      public override function applyServerAction(cmd: CommunicationCommand): void {
         MSquadKillReward.getInstance().multiplier = cmd.parameters.multiplier;
      }
   }
}