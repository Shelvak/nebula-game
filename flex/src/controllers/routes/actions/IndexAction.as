package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;
   
   
   public class IndexAction extends CommunicationAction
   {
      public function IndexAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         SquadronsController.getInstance().createRoutes(cmd.parameters.routes);
      }
   }
}