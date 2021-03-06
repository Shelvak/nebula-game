package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.notification.MSuccessEvent;

   import models.notification.MTimedEvent;
   
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
         super.result(rmo);
         if (ML.latestPlanet != null)
            new MSuccessEvent(Localizer.string('SSObjects', 'message.planetRenamed',
               [ML.latestPlanet.ssObject.name]));
      }
   }
}