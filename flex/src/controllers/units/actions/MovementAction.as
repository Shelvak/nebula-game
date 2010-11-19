package controllers.units.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.units.SquadronsController;
   
   import models.BaseModel;
   import models.factories.UnitFactory;
   import models.movement.MHop;
   
   import mx.collections.ArrayCollection;
   
   
   /**
    * Updates moving squadron
    * 
    * <p>
    * Server will send:
    * <ul>
    *    <li>next route hop for ENEMY and NAP squadrons if they moved in the same map</li>
    *    <li>id of a NAP or ENEMY squadron to hide (destroy) if it has left player's visible area</li>
    *    <li>list of NAP or ENEMY units that have entered players visible area along with next hop</li>
    *    <li>list of units belonging to any player if those units have made a jump between two maps
    *        along with route hops in a new map</li>
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
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
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
            SQUADS_CTRL.destroySquadron(params.hideId);
         }
            // we have received next hop for hostile squad
         else if ((params.units as Array).length == 0)
         {
            SQUADS_CTRL.addHopToSquadron(params.routeHops[0]);
         }
            // friendly squadron made a jump between maps or hostile squadron jumped into players visible area
         else
         {
            SQUADS_CTRL.executeJump(
               UnitFactory.fromObjects(params.units),
               BaseModel.createCollection(ArrayCollection, MHop, params.routeHops)
            );
         }
      }
   }
}