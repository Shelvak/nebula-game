package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   
   import globalevents.GCreditEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Used for accelerating buildings upgrade process
    */
   public class AccelerateUpgradeAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         new GCreditEvent(GCreditEvent.ACCELERATE_CONFIRMED);
      }
   }
}