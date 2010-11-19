package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   
   import models.factories.PlanetFactory;
   import models.factories.SSObjectFactory;
   import models.factories.UnitFactory;
   import models.planet.Planet;
   import models.solarsystem.SSObject;
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
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         var planet:SSObject = SSObject(cmd.parameters.planet);
         // Players can't enter a planet if it is not owned by them
         if (!planet.isOwnedByCurrent)
         {
            return;
         }
         GlobalFlags.getInstance().lockApplication = true;
         sendMessage(new ClientRMO({"id": planet.id}));
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var planet:Planet = PlanetFactory.fromSSObject(
            SSObjectFactory.fromObject(params.planet),
            params.tiles,
            params.buildings,
            params.folliages
         );
         ML.units.addAll(UnitFactory.fromObjects(params.units));
         ML.units.addAll(UnitFactory.fromObjects(ArrayUtil.fromObject(params.npcUnits)));
         planet.initUpgradeProcess();
         
         // If we jumped right to this planet not going through solar system
         // create a fake solar system in model locator with correct id
         if (ML.latestSolarSystem == null || ML.latestSolarSystem.id != planet.solarSystemId)
         {
            if (ML.latestSolarSystem)
            {
               ML.latestSolarSystem.setFlag_destructionPending();
               ML.latestSolarSystem = null;
            }
            var ss:SolarSystem = new SolarSystem();
            ss.fake = true;
            ss.id = planet.solarSystemId;
            ML.latestSolarSystem = ss;
         }
         
         ML.latestPlanet = null;
         SQUADS_CTRL.createSquadronsForUnits(planet.units);
         NavigationController.getInstance().showPlanet(planet);
         GlobalFlags.getInstance().lockApplication = false;
         dispatchPlanetBuildingsChangeEvent();
      }
      
      private function dispatchPlanetBuildingsChangeEvent() : void
      {
         new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
      }
   }
}