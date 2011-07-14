package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;
   
   import models.ModelsCollection;
   import models.location.Location;
   import models.location.LocationType;
   import models.movement.MRoute;
   import models.unit.UnitBuildingEntry;
   
   
   public class IndexAction extends CommunicationAction
   {
      private function get SQUAD_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      public function IndexAction() {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         SQUAD_CTRL.destroyAllMovingFriendlySquadrons();
         SQUAD_CTRL.createRoutes(cmd.parameters.routes, cmd.parameters.players);
      }
   }
}