package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for dismissing units
    */
   public class DismissAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}
