package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import flash.geom.Rectangle;
   
   import models.ModelsCollection;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.galaxy.Galaxy;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   
   /**
    * Downloads list of solar systems for a galaxy and shows galaxy map.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li>no parameters</li>
    * </ul>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystems</code> - array of generic objects representing solar systems</li>
    * </ul>
    * </p>
    */
   public class ShowAction extends CommunicationAction
   {
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public function ShowAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var galaxy:Galaxy = GalaxyFactory.fromObject({"id": ML.player.galaxyId, "solarSystems": cmd.parameters.solarSystems});
         var fowEntries:Vector.<Rectangle> = GalaxyFactory.createFowEntries(galaxy, cmd.parameters.fowEntries);
         
         // Update existing galaxy if this is not the first solar_systems|index message
         if (ML.latestGalaxy)
         {
            var ssListOld:ModelsCollection = ModelsCollection.createFrom(ML.latestGalaxy.solarSystems);
            var ssListNew:ModelsCollection = ModelsCollection.createFrom(galaxy.solarSystems);
            var ssInNew:SolarSystem;
            var ssInOld:SolarSystem;
            // remove solar systems that became invisible and update all others
            for each (ssInOld in ssListOld)
            {
               ssInNew = ssListNew.findModel(ssInOld.id);
               if (!ssInNew)
               {
                  ML.latestGalaxy.removeSolarSystem(ssInOld);
                  // invalidate cached planet
                  if (ML.latestPlanet && ML.latestPlanet.solarSystemId == ssInOld.id)
                  {
                     ML.latestPlanet = null;
                     if (ML.activeMapType == MapType.PLANET)
                     {
                        NAV_CTRL.toGalaxy();
                     }
                  }
                  // invalidate cached solar system
                  if (ML.latestSolarSystem && ML.latestSolarSystem.id == ssInOld.id)
                  {
                     ML.latestSolarSystem = null;
                     if (ML.activeMapType == MapType.SOLAR_SYSTEM)
                     {
                        NAV_CTRL.toGalaxy();
                     }
                  }
               }
               else
               {
                  ssInOld.metadata = ssInNew.metadata;
               }
            }
            // add solar systems that were not visible before
            for each (ssInNew in ssListNew)
            {
               ssInOld = ssListOld.findModel(ssInNew.id);
               if (!ssInOld)
               {
                  ML.latestGalaxy.addSolarSystem(ssInNew);
               }
            }
            ML.latestGalaxy.setFOWEntries(fowEntries);
            return;
         }
         
         galaxy.setFOWEntries(fowEntries);
         
         ML.selectedSSObject = null;
         ML.selectedBuilding = null;
         ML.selectedTechnology = null;
         
         SQUADS_CTRL.distributeUnitsToSquadrons(UnitFactory.fromStatusHash(cmd.parameters.units));
         NAV_CTRL.showGalaxy(galaxy);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}