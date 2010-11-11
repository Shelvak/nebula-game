package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.factories.SSObjectFactory;
   
   public class PlayerIndexAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.player.planets.removeAll();
         for each (var object:Object in cmd.parameters.planets)
         {
            ML.player.planets.addItem(SSObjectFactory.fromObject(object));
         }
      }
   }
}