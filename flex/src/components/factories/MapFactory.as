package components.factories
{
   import components.base.viewport.ViewportZoomable;
   import components.battle.BattleMap;
   import components.map.CMap;
   import components.map.controllers.GalaxyViewportController;
   import components.map.controllers.IMapViewportController;
   import components.map.controllers.SolarSystemViewportController;
   import components.map.controllers.ViewportZoomController;
   import components.map.planet.PlanetMap;
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   
   import models.battle.Battle;
   import models.galaxy.Galaxy;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.Planet;
   import models.solarsystem.SolarSystem;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Lets easily create different type maps. 
    */   
   public class MapFactory
   {
      /* ########### */
      /* ### MAP ### */
      /* ########### */
      
      
      /**
       * Creates a map of a given galaxy model.
       *  
       * @param g A galaxy for which a map must be constructed.
       * 
       * @return Newly created instance of <code>CMapGalaxy</code> that
       * represents the given galaxy.
       */	   
      public static function galaxyMap(g:Galaxy) : CMapGalaxy
      {
         return new CMapGalaxy(g);
      }
      
      
      /**
       * Creates a map of a given solar system (with planets).
       * 
       * @param ss A solar system for which a map must be constructed.
       * 
       * @return Newly created instance of <code>CMapSolarSystem</code>
       * that represents the given solar system.
       */		
      public static function ssMap(ss:SolarSystem) : CMapSolarSystem
      {
         return new CMapSolarSystem(ss);
      }
      
      
      /**
       * Creates a map of a given planet (with planets).
       * 
       * @param p A planet for which map must be contructed.
       * 
       * @return Newly created instancew of <code>PlanetMap</code>
       * that represents the given planet.
       */		
      public static function planetMap(p:Planet) : PlanetMap
      {
         return new PlanetMap(p);
      }
      
      
      private static function battleMap(b:Battle) : Object
      {
         return new BattleMap(b);
      }
      
      
      private static const MAP_FACTORY_METHODS:Object = {
         (String (MapType.GALAXY)): galaxyMap,
         (String (MapType.SOLAR_SYSTEM)): ssMap,
         (String (MapType.PLANET)): planetMap,
         (String (MapType.BATTLE)): battleMap
      };
      
      
      /**
       * Maps type of a map to <code>IMapViewportController</code> implementation
       * to be used for that type of map.
       */
      private static const VIEWPORT_CONTROLLERS:Object = {
         (String (MapType.GALAXY)): GalaxyViewportController,
         (String (MapType.SOLAR_SYSTEM)): SolarSystemViewportController,
         (String (MapType.PLANET)): ViewportZoomController,
         (String (MapType.BATTLE)): null
      }
         
         
         /**
          * Creates and returns map component for the given model.
          * Actual component type will be determined by <code>model.mapType</code>.
          */
         public static function getMap(model:MMap) : CMap
         {
            return CMap((MAP_FACTORY_METHODS[model.mapType] as Function).call(null, model));
         }
         
         
         /* ######################### */
         /* ### VIEWPORT WITH MAP ### */
         /* ######################### */
         
         
         /**
          * Creates and returns <code>ViewportZoomable</code> with map set.
          * 
          * @param model model of a map to create map component and then viewport component for.
          *  
          * @return ready to use isntance of <code>ViewportZoomable</code>
          */
         public static function getViewportWithMap(model:MMap) : ViewportZoomable
         {
            var viewport:ViewportZoomable = new ViewportZoomable();
            viewport.paddingHorizontal = 300;
            viewport.paddingVertical = 300;
            var map:CMap = getMap(model);
            map.viewport = viewport;
            with (viewport)
            {
               left = right = top = bottom = 0;
               if (model.mapType == MapType.GALAXY || model.mapType == MapType.SOLAR_SYSTEM)
               {
                  underlayImage = ImagePreloader.getInstance().getImage(AssetNames.getSpaceBackgroundImageName());
                  underlayScrollSpeedRatio = 0.2;
               }
               content = map;
            }
            return viewport;
         }
         
         
         /* ########################################### */
         /* ### VIEWPORT CONTROLLERS FACTORY METHOD ### */
         /* ########################################### */
         
         
         /**
          * Creates and returns instance of specific implementation of <code>IMapViewportController</code>
          * for a given map.
          * 
          * @param model a map to create controller for
          * 
          * @return instance of specific implementation of <code>IMapViewportController</code>
          * suitable for a given map 
          */
         public static function getViewportController(model:MMap) : IMapViewportController
         {
            if (VIEWPORT_CONTROLLERS[model.mapType] != null)
            {
               var controller:IMapViewportController = new (VIEWPORT_CONTROLLERS[model.mapType] as Class)();
               controller.left = 0;
               controller.right = 0;
               controller.top = 0;
               controller.bottom = 0;
               return controller;
            }
            else
            {
               return null;
            }
         }
   }
}