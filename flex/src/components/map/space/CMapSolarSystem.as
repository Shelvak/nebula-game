package components.map.space
{
   import controllers.Messenger;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMapSolarSystem;
   import models.map.MMapSpace;
   import models.solarsystem.MSSObject;
   
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   import spark.primitives.Ellipse;
   
   import utils.assets.AssetNames;
   import utils.locale.Localizer;
   
   
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
      public static const ORBIT_GAP: Number = MSSObject.IMAGE_WIDTH * 2.5;
      
      /**
       * Gap between the edge of a start and first orbit.
       */ 
      public static const ORBIT_SUN_GAP: Number = MSSObject.IMAGE_WIDTH * 3.5;
      
      /**
       * Ratio of map height and widh ratio (excluding padding).
       */
      public static const HEIGHT_WIDTH_RATIO: Number = 0.35;
      
      /**
       * Increase this to create bigger illusion of perspective in solar system map. 
       */      
      public static const PERSPECTIVE_RATIO: Number = ORBIT_GAP * 0.05;      
      
      
      private var _locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CMapSolarSystem(model:MMapSolarSystem)
      {
         super(model);
      }
      
      /**
       * Called by <code>NavigationController</code> when ssobject map screen is shown.
       */
      public static function screenShowHandler(): void {
         var ssMap:MMapSolarSystem = ModelLocator.getInstance().latestSSMap;
         if (ssMap.solarSystem.isBattleground) {
            Messenger.show(
               Localizer.string("SSObjects", "message.battleground"),
               Messenger.VERY_LONG, 'info/battleground'
            );
         }
      }
      
      
      /**
       * Called by <code>NavigationController</code> when galaxy map screen is hidden.
       */
      public static function screenHideHandler() : void
      {
         Messenger.hide();
      }
      
      protected override function createGrid() : Grid
      {
         return new GridSolarSystem(this);
      }
      
      
      protected override function createCustomComponentClasses() : StaticObjectComponentClasses
      {
         var classes:StaticObjectComponentClasses = new StaticObjectComponentClasses();
         classes.addComponents(MMapSpace.STATIC_OBJECT_COOLDOWN, CCooldown, CCooldownInfo);
         classes.addComponents(MMapSpace.STATIC_OBJECT_NATURAL,  CSSObject, CSSObjectInfo);
         classes.addComponents(MMapSpace.STATIC_OBJECT_WRECKAGE, CWreckage, CWreckageInfo);
         return classes;
      }
      
      
      protected override function createBackgroundObjects(objectsContainer:Group) : void
      {
         // Star
         var star:BitmapImage = new BitmapImage();
         star.verticalCenter = 0;
         star.horizontalCenter = 0;
         star.source = getMapModel().solarSystem.imageData;
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
         left.id = top.id = right.id = bottom.id = getMapModel().id;
         left.type = top.type = right.type = bottom.type = LocationType.SOLAR_SYSTEM;
         for (var position:int = 0; position < getMapModel().orbitsTotal; position++)
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
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      protected override function selectModel(model:BaseModel):void
      {
         if (model is MSSObject)
         {
            super.selectModel(model);
         }
      }
      
      
      protected override function zoomObjectImpl(object:*, operationCompleteHandler:Function=null):void
      {
         if (object is MSSObject)
         {
            super.zoomObjectImpl(object, operationCompleteHandler);
         }
      }
      
      
      /**
       * Typed getter for <code>model</code> property.
       */
      public function getMapModel() : MMapSolarSystem
      {
         return MMapSolarSystem(model);
      }
   }
}