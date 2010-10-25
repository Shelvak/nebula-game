package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.UnitFactory;
   import models.movement.MHop;
   import models.unit.Unit;
   
   
   /**
    * Updates moving squadron
    * 
    * <p>
    * Server will send:
    * <ul>
    *    <li>next route hop for ENEMY and NAP squadrons if they moved in the same map</li>
    *    <li>id of a NAP or ENEMY squadron to hide (destroy) if it has left player's visible area</li>
    *    <li>list of NAP or ENEMY units that have entered players visible area along with next hop</li>
    *    <li>list of units belonging to any player if those units have made a jump between two maps along with route hops
    *        in a new map</li>
    * </ul>
    * </p>
    * 
    * <p>
    * Client <<-- Server:</br>
    * <ul>
    *    <li><code>units</code> - units wrapped with their statuses</li>
    *    <li><code>routeHops</code> - hops of those units route</li>
    *    <li><code>hideId</code> - id of a squadron to hide</li>
    * </ul>
    * </p>
    */
   public class MovementAction extends CommunicationAction
   {
      private var _squadsController:SquadronsController = SquadronsController.getInstance();
      
      
      public function MovementAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         
         // destroy hostile squad as it has left player's visible area
         if (params.hideId != null)
         {
            _squadsController.destroyMovingSquadron(params.hideId);
         }
         // we have received next hop for hostile squad
         else if (params.units == null)
         {
            _squadsController.addHopToHostileSquadron(BaseModel.createModel(MHop, params.routeHops[0]));
         }
         // friendly squadron made a jump between maps or hostile squadron jumped into players visible area
         // NONSENSE HERE
         else
         {
            var units:ModelsCollection = UnitFactory.fromStatusHash(params.units);
            var hops:ModelsCollection = BaseModel.createCollection(ModelsCollection, MHop, params.routeHops);
            _squadsController.createSquadron(units, hops);
         }
      }
   }
}