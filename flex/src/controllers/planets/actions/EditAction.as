package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;
   
   import models.planet.Planet;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Renames a planet.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>id</code> - planet which to rename</li>
    *    <li><code>name</code> - new name of a planet</li>
    * </ul>
    * </p>
    */
   public class EditAction extends CommunicationAction
   {
      public function EditAction()
      {
         super();
      }
      
      public override function result(rmo:ClientRMO):void
      {
         if (ML.latestPlanet)
         {
            Messenger.show(Localizer.string('SSObjects', 'message.planetRenamed', 
               [ML.latestPlanet.ssObject.name]), Messenger.MEDIUM);
         }
      }
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:Planet = Planet(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.id,
            "name": params.ssObject.name
         }, params));
      }
   }
}