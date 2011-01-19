package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;
   
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
      private var transporter: Unit;
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         transporter = Unit(cmd.parameters);
         Collections.filter(ML.units,
            function(unit:Unit) : Boolean
            {
               return unit.location.type == LocationType.UNIT;
            }
         ).removeAll();
         cmd.parameters = {'unitId': transporter.id};
         super.applyClientAction(cmd);
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.units.disableAutoUpdate();
         var playersHash:Object = new Object();
         playersHash[ML.player.id] = {"id": ML.player.id, "name": ML.player.name};
         ML.units.addAll(UnitFactory.fromObjects(cmd.parameters.units, playersHash));
         ML.units.enableAutoUpdate();
         new GUnitEvent(GUnitEvent.UNITS_SHOWN);
      }
   }
}