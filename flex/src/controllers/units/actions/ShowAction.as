package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GUnitEvent;
   
   import models.factories.UnitFactory;
   import models.unit.Unit;
   
   
   /**
    * Used for getting units in other unit
    * param_options :required => %w{unit_id}
    * respond :units => transporter.units
    */
   public class ShowAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var units: Array = [];
         for each (var unit: Object in cmd.parameters.units)
         {
            units.push(UnitFactory.fromObject(unit));
         }
         new GUnitEvent(GUnitEvent.UNITS_SHOWN, units);
      }
   }
}