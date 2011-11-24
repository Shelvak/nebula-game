package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   
   import models.factories.PlanetFactory;
   import models.factories.SSObjectFactory;
   import models.factories.UnitFactory;
   import models.map.MMapSolarSystem;
   import models.planet.MPlanet;
   import models.solarsystem.SSKind;
   import models.solarsystem.MSolarSystem;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Dispached from <code>EventBroker</code> when list of buildings in current
    * planet changes.
    */
   [Event(name="planetBuildingsChange", type="globalevents.GPlanetEvent")]
   
   
   /**
    * Downloads planet form the server, creates a map for it and shows that
    * planet.
    * 
    * <p>
    * Client -->> Server: <code>ShowActionParams</code>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>planet</code> - generic object representing the planet</li>
    *    <li><code>tiles</code> - array of generic objects representing tiles</li>
    *    <li><code>buildings</code> - array of generic objects representing buildings</li>
    *    <li><code>folliages</code> - array of generic objects representing folliages</li>
    *    <li><code>units</code> - array of generic objects representing units</li>
    * </ul>
    * </p>
    * 
    * @see controllers.planets.actions.ShowActionParams
    */
   public class ShowAction extends CommunicationAction
   {
      private function get GF() : ApplicationLocker {
         return ApplicationLocker.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function get SQUADS_CTRL() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      
      // Should applyServerAction() create only the map or also switch screen?
      private var f_createMapOnly:Boolean = false;
      private function resetFlags() : void {
         f_createMapOnly = false;
         GF.lockApplication = false;
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void {
         var params:ShowActionParams = ShowActionParams(cmd.parameters);
         GF.lockApplication = true;
         f_createMapOnly = params.createMapOnly;
         sendMessage(new ClientRMO({"id": params.planetId}));
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         ML.latestPlanet = null;
         var params:Object = cmd.parameters;
         var paramsPlanet:Object = params["planet"];
         ML.units.disableAutoUpdate();
         ML.units.addAll(UnitFactory.fromObjects(params["units"], params["players"]));
         ML.units.addAll(UnitFactory.fromObjects(params["npcUnits"], new Object()));
         ML.units.enableAutoUpdate();
         paramsPlanet["cooldownEndsAt"] = params["cooldownEndsAt"];
         var planet:MPlanet = PlanetFactory.fromSSObject(
            SSObjectFactory.fromObject(paramsPlanet),
            params["tiles"],
            params["buildings"],
            params["folliages"]
         );
         planet.initUpgradeProcess();
         var ss:MSolarSystem;

         // special case for wormholes here since wormhole id and planet.solarSystemId never match
         if (planet.inBattleground) {
            if (ML.latestGalaxy.hasWormholes) {
               if (ML.latestSSMap == null
                      || !ML.latestSSMap.solarSystem.isWormhole
                            && !ML.latestSSMap.solarSystem.isGlobalBattleground) {
                  if (ML.latestSSMap != null) {
                     ML.latestSSMap.setFlag_destructionPending();
                  }
                  ss = new MSolarSystem();
                  ss.fake = true;
                  var wormholeInGalaxy: MSolarSystem =
                         MSolarSystem(ML.latestGalaxy.wormholes.getItemAt(0));
                  ss.id = wormholeInGalaxy.id;
                  ss.x = wormholeInGalaxy.x;
                  ss.y = wormholeInGalaxy.y;
                  ss.kind = SSKind.WORMHOLE;
                  ML.latestSSMap = new MMapSolarSystem(ss);
               }
            }
            else {
               if (ML.latestSSMap != null) {
                  ML.latestSSMap.setFlag_destructionPending();
                  ML.latestSSMap = null;
               }
            }
         }
         // If we jumped right to this planet not going through solar system
         // create a fake solar system in model locator with correct id
         else if (ML.latestSSMap == null || ML.latestSSMap.id != planet.solarSystemId)
         {
            if (ML.latestSSMap != null)
            {
               ML.latestSSMap.setFlag_destructionPending();
            }
            ss = new MSolarSystem();
            ss.fake = true;
            ss.id = planet.solarSystemId;
            var ssInGalaxy:MSolarSystem = ML.latestGalaxy.getSSById(ss.id);
            if (ssInGalaxy == null) {
               throw new Error(
                  "Can't find solar system with id " + ss.id + " in galaxy."
               );
            }
            ss.x = ssInGalaxy.x;
            ss.y = ssInGalaxy.y;
            ss.kind = ssInGalaxy.kind;
            ML.latestSSMap = new MMapSolarSystem(ss);
         }
         
         SQUADS_CTRL.createSquadronsForUnits(planet.units, planet);
         SQUADS_CTRL.attachJumpsAtToHostileSquads(planet.squadrons, params["nonFriendlyJumpsAt"]);
         planet.dispatchUnitRefreshEvent();
         if (f_createMapOnly)
            NAV_CTRL.recreateMap(planet);
         else
            NAV_CTRL.showPlanet(planet);
         dispatchPlanetBuildingsChangeEvent();
         resetFlags();
      }
      
      private function dispatchPlanetBuildingsChangeEvent() : void {
         new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
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
