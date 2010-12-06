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
         super.applyClientAction(cmd);
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.units.addAll(UnitFactory.fromObjects(cmd.parameters.units, cmd.parameters.players));
         new GUnitEvent(GUnitEvent.UNITS_SHOWN);
      }
   }
}