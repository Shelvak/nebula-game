package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.Owner;
   import models.factories.SSObjectFactory;
   import models.solarsystem.SSObject;
   
   public class PlayerIndexAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.player.planets.removeAll();
         for each (var object:Object in cmd.parameters.planets)
         {
            var planet:SSObject = SSObjectFactory.fromObject(object);
            planet.owner = Owner.PLAYER;
            ML.player.planets.addItem(planet);
         }
      }
   }
}