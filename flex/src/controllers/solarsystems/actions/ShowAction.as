package controllers.solarsystems.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import models.factories.SolarSystemFactory;
   import models.factories.UnitFactory;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Downloads objects for one solar system and shows solar system map.
    * 
    * <p>
    * Client -->> Server: <code>ShowActionParams</code>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystem</code> - a generic object that represents a solar system</li>
    *    <li><code>ssObjects</code> - array of generic objects representing objects in the solar system</li>
    * </ul>
    * </p>
    * 
    * @see controllers.solarsystems.actions.ShowActionParams
    */
   public class ShowAction extends CommunicationAction
   {
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      
      public function ShowAction()
      {
         super();
      }
      
      // Should applyServerAction() create only the map or also switch screen?
      private var f_createMapOnly:Boolean = false;
      private function resetFlags() : void {
         f_createMapOnly = false;
         GF.lockApplication = false;
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void {
         GF.lockApplication = true;
         var params:ShowActionParams = ShowActionParams(cmd.parameters);
         f_createMapOnly = params.createMapOnly;
         sendMessage(new ClientRMO({"id": params.solarSystemId}));
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         var params:Object = cmd.parameters;
         
         // objects come as separate parameter so put it to the solar system
         params.solarSystem.ssObjects = params.ssObjects;
         params.solarSystem.wreckages = params.wreckages;
         params.solarSystem.cooldowns = params.cooldowns;
         
         var ss:SolarSystem = SolarSystemFactory.fromObject(params.solarSystem);
         
         // destroy latest a planet if its not in the given solar system
         if (ML.latestPlanet != null && (!ML.latestPlanet.inBattleground || !ss.isGlobalBattleground)) {
            if ( !(ML.latestPlanet.inBattleground && ss.isGlobalBattleground ||
                   ML.latestPlanet.solarSystemId == ss.id) ) {
               ML.latestPlanet.setFlag_destructionPending();
               ML.latestPlanet = null;
            }
         }
         // destroy old solar system
         if (ML.latestSolarSystem != null) {
            ML.latestSolarSystem.setFlag_destructionPending();
            ML.latestSolarSystem = null;
         }
         var units:ArrayCollection = UnitFactory.fromObjects(params.units, params.players);
         ML.units.disableAutoUpdate();
         ML.units.addAll(units);
         ML.units.enableAutoUpdate();
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(params.routeHops);
         if (f_createMapOnly)
            NAV_CTRL.recreateMap(ss);
         else
            NAV_CTRL.showSolarSystem(ss);
         resetFlags();
      }
      
      
      public override function cancel(rmo:ClientRMO) : void {
         resetFlags();
         super.cancel(rmo);
      }
      
      public override function result(rmo:ClientRMO) : void {
         resetFlags();
         super.result(rmo);
      }
   }
}