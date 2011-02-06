package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GResourcesEvent;
   import globalevents.GUnitEvent;
   
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
      public override function result(rmo:ClientRMO) : void
      {
         new GResourcesEvent(GResourcesEvent.WRECKAGES_UPDATED);
         new GUnitEvent(GUnitEvent.LOAD_APPROVED);
      }
   }
}