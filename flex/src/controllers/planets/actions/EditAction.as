package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;
   
   import models.planet.MPlanet;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Renames a planet.
    * 
    * <p>Client -->> Server: <code>EditActionParams</code><p/>
    * 
    * @see EditActionParams
    */
   public class EditAction extends CommunicationAction
   {
      public function EditAction() {
         super();
      }
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         var params:EditActionParams = EditActionParams(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.planet.id,
            "name": params.newName
         }, params.planet));
      }
      
      public override function result(rmo:ClientRMO):void {
         if (ML.latestPlanet != null)
            Messenger.show(Localizer.string('SSObjects', 'message.planetRenamed', 
               [ML.latestPlanet.ssObject.name]), Messenger.MEDIUM);
      }
   }
}