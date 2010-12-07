package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectTile;
   
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import flash.geom.Point;
   
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.solarsystem.SSObject;
   import models.solarsystem.SolarSystem;
   
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   import spark.primitives.Ellipse;
   
   import utils.assets.AssetNames;
   
   
   /**
    * Solar system map. There is a sun in the middle and a few planets around
    * it in different orbits. 
    */   
   public class CMapSolarSystem extends CMapSpace
   {  
      /**
       * Width and height of star image.
       */
      public static const STAR_WH:Number = 300;
      
      /**
       * Gap between orbits of two planets. 
       */	   
      public static const ORBIT_GAP: Number = SSObject.IMAGE_WIDTH * 2.5;
      
      /**
       * Gap between the edge of a start and first orbit.
       */ 
      public static const ORBIT_SUN_GAP: Number = SSObject.IMAGE_WIDTH * 3.5;
      
      /**
       * Ratio of map height and widh ratio (excluding padding).
       */
      public static const HEIGHT_WIDTH_RATIO: Number = 0.35;
      
      /**
       * Increase this to create bigger illusion of perspective in solar system map. 
       */      
      public static const PERSPECTIVE_RATIO: Number = ORBIT_GAP * 0.05;      
      
      private var _locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
      
      
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      
      /**
       * List of planets that are on the map at the moment. 
       */
      private var _objects: Array = null;
      
      
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
         deselectSelectedSSObject();
      }
      
      
      override protected function createGrid() : void
      {
         grid = new GridSolarSystem(this);
      }
      
      
      protected override function createBackgroundObjects(objectsContainer:Group) : void
      {
         // Star
         var star:BitmapImage = new BitmapImage();
         star.verticalCenter = 0;
         star.horizontalCenter = 0;
         star.source = IMG.getImage(AssetNames.getSSImageName(SolarSystem(model).variation));
         objectsContainer.addElement(star);
         
         // Orbits
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
         for (var position:int = 0; position < getSolarSystem().orbitsTotal; position++)
         {
            for each (var location:LocationMinimal in [left, right, top, bottom])
            {
               _locWrapper.location = location;
               _locWrapper.position = position;
            }
            var orbit:Ellipse = new Ellipse();
            orbit.x = grid.getSectorRealCoordinates(left).x;
            orbit.y = grid.getSectorRealCoordinates(top).y;
            orbit.width = grid.getSectorRealCoordinates(right).x - orbit.x;
            orbit.height = grid.getSectorRealCoordinates(bottom).y - orbit.y;
            orbit.stroke = new SolidColorStroke(0x2f2f2f, 3);
            objectsContainer.addElement(orbit);
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
       * Finds and returns a <code>SSObjectTile</code> component that represent the given
       * solar system object model.
       * 
       * @param ssObject A model of a tile to look.
       * 
       * @return A <code>SSObjectTile</code> instance that represents the given <code>ssObject</code>
       * or <code>null</code> if one can't be found.
       */
      protected function getSSObjectTileByModel(ssObject:SSObject) : SSObjectTile
      {
         if (!ssObject)
         {
            return null;
         }
         for each (var tile:SSObjectTile in _objects)
         {
            if (tile.model.equals(ssObject))
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
         if (object is SSObject)
         {
            selectSSObject(getSSObjectTileByModel(SSObject(object)), true);
         }
      }
      
      
      public override function selectComponent(component:Object) : void
      {
         selectSSObject(SSObjectTile(component));
      }
      
      
      public override function deselectSelectedObject() : void
      {
         deselectSelectedSSObject();
      }
      
      
      private function selectSSObject(object:SSObjectTile, moveMap:Boolean = false) : void
      {
         if (!object.selected)
         {
            deselectSelectedSSObject();
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
      public function deselectSelectedSSObject() :void
      {
         for each (var ssObject:SSObjectTile in _objects)
         {
            if (ssObject.selected)
            {
               ssObject.selected = false;
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