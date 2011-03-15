package controllers.buildings.actions
{
   import controllers.CommunicationAction;
   
   import utils.remote.rmo.ClientRMO;

   /**
    * Used for accelerating buildings construction process
    */
   public class AccelerateConstructionAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         
      }
   }
}