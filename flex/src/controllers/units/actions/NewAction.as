package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GObjectEvent;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;

   /**
    * Used for constructing new unit
    */
   public class NewAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO):void
      {
         super.cancel(rmo, srmo);
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
   }
}