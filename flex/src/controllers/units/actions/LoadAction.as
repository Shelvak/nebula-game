package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   
   import globalevents.GUnitEvent;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for loading units
    * param_options :required => %w{unit_ids transporter_id}
    */
   public class LoadAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         new GUnitEvent(GUnitEvent.LOAD_APPROVED);
      }
   }
}