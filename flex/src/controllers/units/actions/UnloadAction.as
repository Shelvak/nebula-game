package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   
   /**
    * Used for unloading units
    * param_options :required => %w{unit_ids transporter_id}
    */
   public class UnloadAction extends CommunicationAction
   {
      public override function result():void
      {
         new GUnitEvent(GUnitEvent.LOAD_APPROVED);
      }
   }
}