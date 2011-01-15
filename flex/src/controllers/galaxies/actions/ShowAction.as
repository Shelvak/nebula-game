package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import flash.geom.Rectangle;
   
   import interfaces.ICleanable;
   
   import models.MStaticSpaceObjectsAggregator;
   import models.MWreckage;
   import models.ModelsCollection;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.datastructures.Collections;
   
   
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
      private var G_FLAGS:GlobalFlags = GlobalFlags.getInstance();
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public function ShowAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         G_FLAGS.lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var galaxy:Galaxy = GalaxyFactory.fromObject({
            "id": ML.player.galaxyId,
            "solarSystems": params.solarSystems,
            "wreckages": params.wreckages
         });
         var fowEntries:Vector.<Rectangle> = GalaxyFactory.createFowEntries(galaxy, params.fowEntries);
         var units:IList = UnitFactory.fromObjects(params.units, params.players);
         
         // Update existing galaxy if this is not the first solar_systems|index message
         if (ML.latestGalaxy)
         {
            var ssListOld:ModelsCollection = ModelsCollection.createFrom(ML.latestGalaxy.naturalObjects);
            var ssListNew:ModelsCollection = ModelsCollection.createFrom(galaxy.naturalObjects);
            var ssInNew:SolarSystem;
            var ssInOld:SolarSystem;
            // remove solar systems that became invisible and update all others
            for each (ssInOld in ssListOld)
            {
               ssInNew = ssListNew.find(ssInOld.id);
               if (!ssInNew)
               {
                  ML.latestGalaxy.removeObject(ssInOld);
                  // invalidate cached planet
                  if (ML.latestPlanet && ML.latestPlanet.solarSystemId == ssInOld.id)
                  {
                     ML.latestPlanet.setFlag_destructionPending();
                     ML.latestPlanet = null;
                     if (ML.activeMapType == MapType.PLANET)
                     {
                        NAV_CTRL.toGalaxy();
                     }
                  }
                  // invalidate cached solar system
                  if (ML.latestSolarSystem && ML.latestSolarSystem.id == ssInOld.id)
                  {
                     ML.latestSolarSystem.setFlag_destructionPending();
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
               ssInOld = ssListOld.find(ssInNew.id);
               if (!ssInOld)
               {
                  ML.latestGalaxy.addObject(ssInNew);
               }
            }
            
            
            var wreckListOld:ModelsCollection = ModelsCollection.createFrom(ML.latestGalaxy.wreckages);
            var wreckListNew:ModelsCollection = ModelsCollection.createFrom(galaxy.wreckages);
            var wreckInNew:MWreckage;
            var wreckInOld:MWreckage;
            // update wreckages that became abscent and update all others
            for each (wreckInOld in wreckListOld)
            {
               wreckInNew = wreckListNew.find(wreckInOld.id);
               if (!wreckInNew)
               {
                  ML.latestGalaxy.removeObject(wreckInOld);
               }
               else
               {
                  wreckInOld.copyProperties(wreckInNew);
               }
            }
            // add wreckages that were not visible before
            for each (wreckInNew in wreckListNew)
            {
               wreckInOld = wreckListOld.find(wreckInNew.id);
               if (!wreckInOld)
               {
                  ML.latestGalaxy.addObject(wreckInNew);
               }
            }
            
            
            Collections.cleanListOfICleanables(ML.latestGalaxy.squadrons);
            Collections.cleanListOfICleanables(ML.latestGalaxy.units);
            ML.latestGalaxy.setFOWEntries(fowEntries, units);
         }
         else
         {
            ML.selectedBuilding = null;
            ML.selectedFolliage = null;
            ML.selectedTechnology = null;
         }
         
         galaxy.setFOWEntries(fowEntries, units);
         ML.units.addAll(units);
         SQUADS_CTRL.createSquadronsForUnits(units);
         SQUADS_CTRL.addHopsToSquadrons(params.routeHops);
         if (!ML.latestGalaxy)
         {
            NAV_CTRL.showGalaxy(galaxy);
            G_FLAGS.lockApplication = false;
         }
      }
   }
}