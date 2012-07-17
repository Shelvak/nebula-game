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
    * param_options :required => %w{unit_ids}
    * respond :units => each (transporter.units)
    */
   public class ShowAction extends CommunicationAction
   {
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.units.disableAutoUpdate();
         var playersHash:Object = new Object();
         playersHash[ML.player.id] = {"id": ML.player.id, "name": ML.player.name};
         ML.units.addAll(UnitFactory.fromObjects(cmd.parameters.units, playersHash));
         ML.units.enableAutoUpdate();
         if (ML.latestPlanet)
         {
            ML.latestPlanet.invalidateUnitCachesAndDispatchEvent();
         }
         new GUnitEvent(GUnitEvent.UNITS_SHOWN);
      }
   }
}