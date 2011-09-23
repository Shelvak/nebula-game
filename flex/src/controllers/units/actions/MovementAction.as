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
    *    <li>list of any units that have entered players visible area along with next hop</li>
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
    * </ul>
    * </p>
    */
   public class MovementAction extends CommunicationAction
   {
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      public function MovementAction() {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         // we have received next hop for hostile squad
         if ((params.units as Array).length == 0)
            SQUADS_CTRL.addHopToSquadron(BaseModel.createModel(MHop, params.routeHops[0]));
         // friendly squadron made a jump between maps or a squadron jumped into players visible area
         else
            SQUADS_CTRL.executeJump(
               UnitFactory.fromObjects(params.units, params.players),
               BaseModel.createCollection(ArrayCollection, MHop, params.routeHops)
            );
      }
   }
}