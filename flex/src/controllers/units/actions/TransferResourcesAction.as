package controllers.units.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import globalevents.GResourcesEvent;

   import models.notification.MTimedEvent;

   import models.resource.Resource;
   import models.resource.ResourceType;

   import utils.locale.Localizer;

   import utils.remote.rmo.ClientRMO;

   /**
    * Used for loading resources
    *  # Parameters:
  # - transporter_id (Fixnum): ID of transporter Unit.
  # - metal (Float): Amount of metal to load.
  # - energy (Float): Amount of energy to load.
  # - zetium (Float): Amount of zetium to load.
    */
   public class TransferResourcesAction extends CommunicationAction
   {
      public override function applyServerAction(cmd: CommunicationCommand): void {
         var keptResources: Object = cmd.parameters.keptResources;
         if (keptResources.metal > 0
            || keptResources.energy > 0
            || keptResources.zetium > 0)
         {
            var resources: Array = [];
            var amounts: Array = [];
            function addIfNeeded(name: String, amount: int): void
            {
               if (amount > 0)
               {
                  resources.push(name);
                  amounts.push(amount);
               }
            }
            addIfNeeded(ResourceType.METAL, keptResources.metal);
            addIfNeeded(ResourceType.ENERGY, keptResources.energy);
            addIfNeeded(ResourceType.ZETIUM, keptResources.zetium);
            new MTimedEvent(Localizer.string('Units', 'message.didNotFit',
               [Resource.getResourceString(resources, amounts)]));
         }
      }

      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         new GResourcesEvent(GResourcesEvent.WRECKAGES_UPDATED);
      }
   }
}