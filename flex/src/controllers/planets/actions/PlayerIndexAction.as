package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.Owner;
   import models.factories.SSObjectFactory;
   import models.solarsystem.MSSObject;
   
   import utils.datastructures.Collections;
   
   public class PlayerIndexAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         Collections.cleanListOfICleanables(ML.player.planets);
         for each (var object:Object in cmd.parameters.planets)
         {
            var planet:MSSObject = SSObjectFactory.fromObject(object);
            planet.player = ML.player;
            planet.owner = Owner.PLAYER;
            planet.viewable = true;
            ML.player.planets.addItem(planet);
         }
      }
   }
}