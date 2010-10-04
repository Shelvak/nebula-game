package controllers.units.actions
{
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   
   /**
    * Used for updating units
    */
   public class UpdateAction extends CommunicationAction
   {
      public override function result():void
      {
         new GUnitEvent(GUnitEvent.FLANK_APPROVED);
      }
   }
}