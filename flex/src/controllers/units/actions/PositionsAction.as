package controllers.units.actions
{
   import components.squadronsscreen.OverviewUnits;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import utils.remote.rmo.ClientRMO;

   /**
    * Returns all unit positions and counts in given scope, structured in such
    # hash:
    # {
    #   player_id (Fixnum) => {
    #     "#{location_id},#{location_type}" => {
    #       "location" => ClientLocation#as_json,
    #       "cached_units" => {type (String) => count (Fixnum)}
    #     },
    #   },
    # }
    # 
    * @author Jho
    * 
    */   
   public class PositionsAction extends CommunicationAction
   {
      private function get OU(): OverviewUnits
      {
         return OverviewUnits.getInstance();
      }
      
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         OU.setData(cmd.parameters.positions, cmd.parameters.players);
         NavigationController.getInstance().showSquadrons();
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}