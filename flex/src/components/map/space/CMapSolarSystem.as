package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectTile;
   import components.gameobjects.solarsystem.Orbit;
   import components.gameobjects.solarsystem.Star;
   
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.planet.Planet;
   import models.solarsystem.SSObject;
   import models.solarsystem.SolarSystem;
   
   import spark.components.Group;
   
   
   /**
    * Solar system map. There is a sun in the middle and a few planets around
    * it in different orbits. 
    */   
   public class CMapSolarSystem extends CMapSpace
   {
      /**
       * Gap between orbits of two planets. 
       */	   
      public static const ORBIT_GAP: Number = SSObject.IMAGE_WIDTH * 2;
      
      
      /**
       * Gap between the edge of a start and first orbit.
       */ 
      public static const ORBIT_SUN_GAP: Number = SSObject.IMAGE_WIDTH * 2;
      
      
      /**
       * Ratio of map height and widh ratio (excluding padding).
       */
      public static const HEIGHT_WIDHT_RATIO: Number = 0.325;
      
      
      private var _locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
      
      
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      
      /**
       * Sun component (placed in the middle). Won't change when model is
       * changed.
       */
      private var _star: Star = null;
      
      
      /**
       * List of planets that are on the map at the moment. 
       */
      private var _objects: Array = null;
      
      
      /**
       * List of orbits of planets'. 
       */
      private var _orbits: Array = null;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function CMapSolarSystem(model:SolarSystem)
      {
         super(model);
      }
      
      
      override protected function reset() : void
      {
         deselectSelectedPlanet();
      }
      
      
      override protected function createGrid() : void
      {
         grid = new GridSolarSystem(this);
      }
      
      
      protected override function createBackgroundObjects(objectsContainer:Group) : void
      {
         // Star
         _star = new Star();
         _star.model = model;
         _star.verticalCenter = 0;
         _star.horizontalCenter = 0;
         objectsContainer.addElement(_star);
         
         // Orbits
         _orbits = new Array();
         var orbit:Orbit = null;
         var left:LocationMinimal = new LocationMinimal();
         _locWrapper.location = left;
         _locWrapper.angle = 180;
         var top:LocationMinimal = new LocationMinimal();
         _locWrapper.location = top;
         _locWrapper.angle = 270;
         var right:LocationMinimal = new LocationMinimal();
         _locWrapper.location = right;
         _locWrapper.angle = 0;
         var bottom:LocationMinimal = new LocationMinimal();
         _locWrapper.location = bottom;
         _locWrapper.angle = 90;
         left.id = top.id = right.id = bottom.id = getSolarSystem().id;
         var createdOrbits:Object = new Object();
         for each (var object:SSObject in getSolarSystem().objects)
         {
            for each (var location:LocationMinimal in [left, right, top, bottom])
            {
               _locWrapper.location = location;
               _locWrapper.position = object.position;
            }
            if (!createdOrbits[object.position])
            {
               orbit = new Orbit();
               orbit.x = grid.getSectorRealCoordinates(left).x;
               orbit.y = grid.getSectorRealCoordinates(top).y;
               orbit.width = grid.getSectorRealCoordinates(right).x - orbit.x;
               orbit.height = grid.getSectorRealCoordinates(bottom).y - orbit.y;
               _orbits.push(orbit);
               objectsContainer.addElement(orbit);
               createdOrbits[object.position] = true;
            }
         }
      }
      
      
      protected override function createStaticObjects(objectsContainer:Group) : void
      {
         var tile:SSObjectTile = null;
         _objects = new Array();
         for each (var object:SSObject in getSolarSystem().objects)
         {
            tile = new SSObjectTile();
            tile.model = object;
            _objects.push(tile);
            objectsContainer.addElement(tile);
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Finds and returns a <code>PlanetTile</code> component that represent the given
       * planet model.
       * 
       * @param planet A model of a tile to look.
       * 
       * @return A <code>PlanetTile</code> instance that represents the given <code>planet</code>
       * or <code>null</code> if one can't be found.
       */
      protected function getSSObjectTileByModel(planet:Planet) : SSObjectTile
      {
         if (!planet)
         {
            return null;
         }
         for each (var tile:SSObjectTile in _objects)
         {
            if (tile.model.equals(planet))
            {
               return tile;
            }
         }
         return null;
      }
      
      
      /* ######################## */
      /* ### PLANET SELECTION ### */
      /* ######################## */
      
      
      protected override function selectModel(object:BaseModel) : void
      {
         if (object is Planet)
         {
            selectSSObject(getSSObjectTileByModel(Planet(object)), true);
         }
      }
      
      
      protected override function this_clickHandler(event:MouseEvent):void
      {
         if (event.target is SSObjectTile && SSObjectTile(event.target).selected)
         {
            selectComponent(event.target);
         }
         else
         {
            super.this_clickHandler(event);
         }
      }
      
      
      protected override function selectComponent(component:Object) : void
      {
         selectSSObject(SSObjectTile(component));
      }
      
      
      protected override function deselectSelectedObject() : void
      {
         deselectSelectedPlanet();
      }
      
      
      private function selectSSObject(object:SSObjectTile, moveMap:Boolean = false) : void
      {
         if (!object.selected)
         {
            deselectSelectedPlanet ();
            ML.selectedSSObject = SSObject(object.model);
            SidebarScreensSwitch.getInstance().showScreen(SidebarScreens.PLANET_INFO);
            if (moveMap)
            {
               viewport.moveContentTo(new Point(object.x, object.y), true);
            }
         }
         object.select();
      }
      
      
      /**
       * Deselects currently selected planet if there is one.
       */ 
      public function deselectSelectedPlanet () :void
      {
         for each (var planet: SSObjectTile in _objects)
         {
            if (planet.selected)
            {
               planet.selected = false;
               ML.selectedSSObject = null;
               SidebarScreensSwitch.getInstance().resetToDefault();
               break;
            }
         }
      }
      
      
      /**
       * Typed gettor for <code>model</code> property.
       */
      public function getSolarSystem() : SolarSystem
      {
         return SolarSystem(model);
      }
   }
}