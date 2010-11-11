package models.location
{
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   
   import models.ModelLocator;
   import models.Player;
   import models.building.Building;
   import models.solarsystem.SSObject;
   import models.solarsystem.SSObjectType;
   import models.tile.TerrainType;
   
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   [ResourceBundle ("Location")]
   
   public class Location extends LocationMinimal
   {
      private var _ssObject:SSObject = new SSObject();
      
      [Optional]
      public var terrain:int = TerrainType.GRASS;
      [Optional]
      public var name:String = null;
      [Optional]
      public var playerId:int = 0;
      [Optional]
      public var solarSystemId:int = 0;
      [Optional]
      public var ssObjectType:String = SSObjectType.PLANET;
      
      
      private var _variation:int;
      [Bindable(event="willNotChange")]
      public function set variation(value:int) : void
      {
         if (_variation != value)
         {
            _variation = value;
         }
      }
      public function get variation() : int
      {
         if (isSSObject)
         {
            _ssObject.terrain = terrain;
            _ssObject.type = ssObjectType;
            return _ssObject.variation;
         }
         return _variation;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get sectorName() :String
      {
         return x + ":" + y;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get solarSystemName() : String
      {
         return NameResolver.resolveSolarSystem(solarSystemId == 0 ? id : solarSystemId);
      }
      
      
      [Bindable(event="willNotChange")]
      public function get planetName() : String
      {
         return name;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get shortDescription() : String
      {
         if (type == LocationType.GALAXY)
         {
            return getString("description.short.galaxy");
         }
         if (type == LocationType.SOLAR_SYSTEM)
         {
            return getString("description.short.solarSystem", [solarSystemName]);
         }
         if (type == LocationType.SS_OBJECT)
         {
            return getString("description.short.planet", [planetName]);
         }
         throwUnsupportedLocationTypeError();
         return null;   // unreachable
      }
      
      
      [Bindable(event="willNotChange")]
      public function get longDescription() : String
      {
         switch(type)
         {
            case LocationType.GALAXY:
               return getString("description.long.galaxy", [x, y]);
            case LocationType.SOLAR_SYSTEM:
               return getString("description.long.solarSystem", [solarSystemName, x, y]);
            case LocationType.SS_OBJECT:
               return getString("description.long.planet", [planetName, solarSystemName]);
         }
         throwUnsupportedLocationTypeError();
         return null;   // unreachable
      }
      
      
      [Bindable(event="willNotChange")]
      public function get hasParent() : Boolean
      {
         return isSSObject;
      };
      
      
      [Bindable(event="willNotChange")]
      public function get bitmapData() : BitmapData
      {
         var imageName:String = null;
         switch(type)
         {
            case LocationType.GALAXY:
               imageName = AssetNames.getGalaxyImageName();
               break;
            
            case LocationType.SOLAR_SYSTEM:
               imageName = AssetNames.getSSImageName(variation);
               break;
            
            case LocationType.SS_OBJECT:
               _ssObject.type = ssObjectType;
               _ssObject.terrain = terrain;
               return _ssObject.imageData;
            
            default:
               throwUnsupportedLocationTypeError();
         }
         return ImagePreloader.getInstance().getImage(imageName);
      }
      
      
      /**
       * Navigates to the map this location represents.
       */
      public function show(zoomObj: *) : void
      {
         var navCtrl:NavigationController = NavigationController.getInstance();
         switch(type)
         {
            case LocationType.GALAXY:
                  navCtrl.toGalaxy();
               break;
            
            case LocationType.SOLAR_SYSTEM:
                  navCtrl.toSolarSystem(id);
               break;
            
            case LocationType.SS_OBJECT:
               if (zoomObj != null && zoomObj is Building)
               {
                  navCtrl.selectBuilding(zoomObj);
               }
               else
               {
                  var obj:SSObject = new SSObject();
                  obj.id = id;
                  obj.solarSystemId = solarSystemId;
                  // This might be true as well as a temporary hack.
                  // The latter is more probable so change this to something else
                  obj.player = ModelLocator.getInstance().player;
                  navCtrl.toPlanet(obj);
               }
               break;
         }
      }
      
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Shortcut for <code>RM.getString("Location", resourceName, parameters)</code>.
       */
      private function getString(resourceName:String, parameters:Array = null) : String
      {
         return RM.getString("Location", resourceName, parameters);
      }
      
      
      /**
       * @throws Error
       */
      private function throwUnsupportedLocationTypeError() : void
      {
         throw new Error("Unsupported location type: " + type);
      }
   }
}