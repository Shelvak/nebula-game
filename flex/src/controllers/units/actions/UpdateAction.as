package controllers.units.actions
{
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for updating units
    */
   public class UpdateAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GUnitEvent(GUnitEvent.FLANK_APPROVED);
      }
   }
}