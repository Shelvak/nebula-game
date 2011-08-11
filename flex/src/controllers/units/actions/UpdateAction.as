package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import globalevents.GUnitEvent;
   
   import models.unit.MCUnitScreen;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for updating units
    */
   public class UpdateAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GUnitEvent(GUnitEvent.FLANK_APPROVED);
         GlobalFlags.getInstance().lockApplication = false;
         MCUnitScreen.getInstance().confirmChanges();
      }
      
      override public function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}