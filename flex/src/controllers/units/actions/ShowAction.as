package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GUnitEvent;
   
   import models.factories.UnitFactory;
   import models.location.LocationType;
   import models.unit.Unit;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Used for getting units in other unit
    * param_options :required => %w{unit_id}
    * respond :units => transporter.units
    */
   public class ShowAction extends CommunicationAction
   {
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         Collections.filter(ML.units,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.UNIT;
            }
         ).removeAll();
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         for each (var unit: Object in cmd.parameters.units)
         {
            ML.units.addItem(UnitFactory.fromObject(unit));
         }
         new GUnitEvent(GUnitEvent.UNITS_SHOWN, units);
      }
   }
}