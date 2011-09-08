package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import globalevents.GUnitEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for unloading units
    * param_options :required => %w{unit_ids transporter_id}
    */
   public class UnloadAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}