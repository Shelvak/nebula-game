package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GObjectEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Used for constructing new unit
    */
   public class NewAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         new GObjectEvent(GObjectEvent.OBJECT_APPROVED);
      }
   }
}