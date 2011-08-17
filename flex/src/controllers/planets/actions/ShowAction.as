package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.screens.MainAreaScreens;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   
   import models.Owner;
   import models.factories.PlanetFactory;
   import models.factories.SSObjectFactory;
   import models.factories.UnitFactory;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSKind;
   import models.solarsystem.SolarSystem;
   
   import utils.ArrayUtil;
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
    * Client -->> Server
    * <ul>
    *    <li><code>planet</code> - a planet to show</li>
    * </ul>
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
    */
   public class ShowAction extends CommunicationAction
   {
      private var GF:GlobalFlags = GlobalFlags.getInstance();
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         var planet:MSSObject = MSSObject(cmd.parameters.planet);
         if (!planet.viewable)
         {
            return;
         }
         GF.lockApplication = true;
         sendMessage(new ClientRMO({"id": planet.id}));
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         ML.units.addAll(UnitFactory.fromObjects(params.units, params.players));
         ML.units.addAll(UnitFactory.fromObjects(params.npcUnits, new Object()));
         params.planet.cooldownEndsAt = params.cooldownEndsAt;
         var planet:Planet = PlanetFactory.fromSSObject(
            SSObjectFactory.fromObject(params.planet),
            params.tiles,
            params.buildings,
            params.folliages
         );
         planet.ssObject.owner = params.planet.lastResourcesUpdate ? Owner.PLAYER : Owner.UNDEFINED;
         planet.initUpgradeProcess();
         var ss:SolarSystem;
         
         // special case for wormholes here since wormhole id and planet.solarSystemId never match
         if (planet.inBattleground)
         {
            if (ML.latestGalaxy.hasWormholes)
            {
               if (ML.latestSolarSystem == null ||
                  !ML.latestSolarSystem.isWormhole && !ML.latestSolarSystem.isGlobalBattleground)
               {
                  if (ML.latestSolarSystem != null)
                  {
                     ML.latestSolarSystem.setFlag_destructionPending();
                  }
                  ss = new SolarSystem();
                  ss.fake = true;
                  var wormholeInGalaxy:SolarSystem = SolarSystem(ML.latestGalaxy.wormholes.getItemAt(0));
                  ss.id = wormholeInGalaxy.id;
                  ss.x  = wormholeInGalaxy.x;
                  ss.y  = wormholeInGalaxy.y;
                  ss.kind = SSKind.WORMHOLE;
                  ML.latestSolarSystem = ss;
               }
            }
            else
            {
               if (ML.latestSolarSystem != null)
               {
                  ML.latestSolarSystem.setFlag_destructionPending();
                  ML.latestSolarSystem = null;
               }
            }
         }
         // If we jumped right to this planet not going through solar system
         // create a fake solar system in model locator with correct id
         else if (ML.latestSolarSystem == null || ML.latestSolarSystem.id != planet.solarSystemId)
         {
            if (ML.latestSolarSystem != null)
            {
               ML.latestSolarSystem.setFlag_destructionPending();
            }
            ss = new SolarSystem();
            ss.fake = true;
            ss.id = planet.solarSystemId;
            var ssInGalaxy:SolarSystem = ML.latestGalaxy.getSSById(ss.id);
            if (ssInGalaxy == null)
            {
               throw new Error("Can't find solar system with id " + ss.id
                  + " in galaxy map. Man, that's funky! " 
                  + "It should be there because you have a planet in it.");
            }
            ss.x = ssInGalaxy.x;
            ss.y = ssInGalaxy.y;
            ML.latestSolarSystem = ss;
         }
         
         if (ML.latestPlanet != null)
         {
            ML.latestPlanet.setFlag_destructionPending();
            ML.latestPlanet = null;
         }
         SQUADS_CTRL.createSquadronsForUnits(planet.units);
         NAV_CTRL.showPlanet(planet);
         GF.lockApplication = false;
         dispatchPlanetBuildingsChangeEvent();
      }
      
      private function dispatchPlanetBuildingsChangeEvent() : void
      {
         new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
      }
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
         GF.lockApplication = false;
      }
   }
}
