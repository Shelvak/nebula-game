package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   
   /**
    * Used for loading resources
    *  # Parameters:
  # - transporter_id (Fixnum): ID of transporter Unit.
  # - metal (Float): Amount of metal to load.
  # - energy (Float): Amount of energy to load.
  # - zetium (Float): Amount of zetium to load.
    */
   public class LoadResourcesAction extends CommunicationAction
   {
      public override function result():void
      {
         new GUnitEvent(GUnitEvent.LOAD_APPROVED);
      }
   }
}