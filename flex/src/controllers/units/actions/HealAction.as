package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for healing units
    * param_options :required => %w{unit_ids building_id}
    */
   public class HealAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}