package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.unit.Unit;
   
   import mx.collections.IList;
   
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
         for each (var unit:Unit in units.toArray())
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
   }
}