package controllers.solarSystems.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import models.Galaxy;
   import models.ModelsCollection;
   import models.factories.GalaxyFactory;
   import models.factories.UnitFactory;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import namespaces.client_internal;
   
   
   /**
    * Downloads list of solar systems for a galaxy and shows galaxy map.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>galaxyId</code> - id of a galaxy</li>
    * </ul>
    * </p>
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>solarSystems</code> - array of generic objects representing solar systems</li>
    * </ul>
    * </p>
    */
   public class IndexAction extends CommunicationAction
   {
      private var _squadsController:SquadronsController = SquadronsController.getInstance();
      private var _navCtrl:NavigationController = NavigationController.getInstance();
      
         
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         super.applyClientAction(cmd);
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var g:Galaxy = GalaxyFactory.fromObject
            ({"id": ML.player.galaxyId, "solarSystems": cmd.parameters.solarSystems});
         
         // Update existing galaxy if this is not the first solar_systems|index message
         if (ML.latestGalaxy)
         {
            var ssListOld:ModelsCollection = new ModelsCollection();
            ssListOld.addAll(ML.latestGalaxy.solarSystems);
            var ssListNew:ModelsCollection = new ModelsCollection();
            ssListNew.addAll(g.solarSystems);
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
                        _navCtrl.toGalaxy();
                     }
                  }
                  // invalidate cached solar system
                  if (ML.latestSolarSystem && ML.latestSolarSystem.id == ssInOld.id)
                  {
                     ML.latestSolarSystem = null;
                     if (ML.activeMapType == MapType.SOLAR_SYSTEM)
                     {
                        _navCtrl.toGalaxy();
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
            ML.latestGalaxy.client_internal::setMinMaxProperties();
            return;
         }
         
         ML.selectedPlanet = null;
         ML.selectedBuilding = null;
         ML.selectedTechnology = null;
         
         _squadsController.distributeUnitsToSquadrons(UnitFactory.fromStatusHash(cmd.parameters.units), g);
         NavigationController.getInstance().showGalaxy(g);
         GlobalFlags.getInstance().lockApplication = false;
      }  
   }
}