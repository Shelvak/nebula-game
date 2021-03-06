package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;

   /**
    *  # Returns portal units that would come to defend this planet.
    #
    # Invocation: by client
    #
    # Parameters:
    # - id (Fixnum): planet id
    #
    # Response:
    # - unit_counts     
    * # {
    # :your => [[type, count], ...],
    # :alliance => [[type, count], ...]
    # }.
    #
    # E.g.:
    # {
    # :your => [["Trooper", 3], ["Shocker", 5], ... ],
    # :alliance => []
    # }
    # - teleport_volume (Fixnum): max volume of units that can be teleported
    # 
    * @author Jho
    * 
    */   
   public class PortalUnitsAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         NavigationController.getInstance().openDefensivePortal(
            cmd.parameters.unitCounts, cmd.parameters.teleportVolume);
      }
   }
}