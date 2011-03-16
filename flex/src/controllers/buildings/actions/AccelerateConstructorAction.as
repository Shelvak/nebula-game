package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import globalevents.GCreditEvent;
   
   import utils.remote.rmo.ClientRMO;

   /**
    * Used for accelerating buildings construction process
    */
   public class AccelerateConstructorAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}