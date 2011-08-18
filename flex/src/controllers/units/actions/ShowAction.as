package controllers.units.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import globalevents.GUnitEvent;
   
   import models.factories.UnitFactory;
   import models.location.LocationType;
   import models.unit.Unit;
   
   import utils.datastructures.Collections;
   import utils.remote.rmo.ClientRMO;
   
   
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
         GlobalFlags.getInstance().lockApplication = true;
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
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.units.disableAutoUpdate();
         var playersHash:Object = new Object();
         playersHash[ML.player.id] = {"id": ML.player.id, "name": ML.player.name};
         ML.units.addAll(UnitFactory.fromObjects(cmd.parameters.units, playersHash));
         ML.units.enableAutoUpdate();
         if (ML.latestPlanet)
         {
            ML.latestPlanet.dispatchUnitRefreshEvent();
         }
         new GUnitEvent(GUnitEvent.UNITS_SHOWN);
      }
   }
}