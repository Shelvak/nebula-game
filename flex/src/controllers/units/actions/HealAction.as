package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GHealingScreenEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for healing units
    * param_options :required => %w{unit_ids building_id}
    */
   public class HealAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GHealingScreenEvent(GHealingScreenEvent.HEAL_APPROVED);
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         new GHealingScreenEvent(GHealingScreenEvent.HEAL_APPROVED);
      }
   }
}