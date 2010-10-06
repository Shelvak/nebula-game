package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GUnitEvent;
   
   
   /**
    * Used for getting units in other unit
    * param_options :required => %w{unit_id}
    * respond :units => transporter.units
    */
   public class ShowAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         new GUnitEvent(GUnitEvent.UNITS_SHOWN, cmd.parameters.units);
      }
   }
}