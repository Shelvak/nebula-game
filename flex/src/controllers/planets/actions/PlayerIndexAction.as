package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.factories.PlanetFactory;
   
   public class PlayerIndexAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.playerPlanets.removeAll();
         for each (var object:Object in cmd.parameters.planets)
         {
            ML.playerPlanets.addItem(PlanetFactory.fromObject(object));
         }
      }
   }
}