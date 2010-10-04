package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import ext.flex.mx.collections.IList;
   
   import globalevents.GUnitEvent;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.planet.Planet;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   
   import namespaces.client_internal;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Order units to move to a new location. Response is received as <code>MOVEMENT_PREPARE</code>
    * action.
    * 
    * <p>
    * Client -->> Server:</br>
    * <ul>
    *    <li><code>units</code> - list of units to move</li>
    *    <li><code>source</code> - current location of units</li>
    *    <li><code>target</code> - units destination</li>
    *    <li><code>jumpgate</code> - instance of <code>Planet</code> units will travel through
    *        (needed only if units move from solar system to a galaxy or other solar system)</li>
    * </ul>
    * </p>
    */
   public class MoveAction extends CommunicationAction
   {
      public function MoveAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         var units:IList = cmd.parameters.units;
         var locSource:LocationMinimal = cmd.parameters.source;
         var locTarget:LocationMinimal = cmd.parameters.target;
         var unitIds:Array = new Array();
         for each (var unit:Unit in units)
         {
            unitIds.push(unit.id);
         }
         
         sendMessage(new ClientRMO({
            "unitIds": unitIds,
            "source": {
               "locationId": locSource.id, "locationType": locSource.type,
               "locationX": locSource.x, "locationY": locSource.y
            },
            "target": {
               "locationId": locTarget.id, "locationType": locTarget.type,
               "locationX": locTarget.x, "locationY": locTarget.y
            },
            "throughId": cmd.parameters.jumpgate ? BaseModel(cmd.parameters.jumpgate).id : null
         }));
      }
      
      
//      public override function applyServerAction(cmd:CommunicationCommand) : void
//      {
//         // Create squadron with units and all hops
//         var squad:MSquadron = BaseModel.createModel(MSquadron, cmd.parameters.route);
//         squad.owner = Owner.PLAYER;
//         squad.units.addAll(_units);
//         squad.client_internal::rebuildCachedUnits();
//         
//         // Add that squadron to ModelLocator
//         SquadronsController.getInstance().startMovement(squad);
//         
//         // Notify UI that order has been executed and release references
//         OrdersController.getInstance().orderComplete();
//         GlobalFlags.getInstance().lockApplication = false;
//         _units = null;
//         _locSource = null;
//         _locTarget = null;
//      }
   }
}