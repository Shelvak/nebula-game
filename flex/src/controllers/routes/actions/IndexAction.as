package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;
   
   
   public class IndexAction extends CommunicationAction
   {
      private function get SQUAD_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      public function IndexAction() {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         if (ML.latestGalaxy == null)
            SQUAD_CTRL.createRoutes(cmd.parameters.routes, cmd.parameters.players);
         else
            SQUAD_CTRL.recreateRoutes(cmd.parameters.routes, cmd.parameters.players);
      }
   }
}