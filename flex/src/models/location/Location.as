package models.location
{
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.map.MapType;
   import models.planet.Planet;
   import models.planet.PlanetClass;
   import models.planet.PlanetType;
   import models.tile.TerrainType;
   
   import mx.resources.ResourceManager;
   
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   [ResourceBundle ("Location")]
   
   public class Location extends LocationMinimal
   {
      [Optional]
      public var variation:int = 0;
      [Optional]
      public var name:String = null;
      [Optional]
      public var playerId:int = 0;
      [Optional]
      public var solarSystemId:int = 0;
      [Optional]
      public var planetClass:String = PlanetClass.LANDABLE;
      
      
      [Bindable(event="willNotChange")]
      public function get galaxySectorName() :String
      {
         return x + ":" + y;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get solarSystemName() : String
      {
         return NameResolver.resolveSolarSystem(solarSystemId);
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
         if (type == LocationType.PLANET)
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
            case LocationType.PLANET:
               return getString("description.long.planet", [planetName, solarSystemName]);
         }
         throwUnsupportedLocationTypeError();
         return null;   // unreachable
      }
      
      
      [Bindable(event="willNotChange")]
      public function get hasParent() : Boolean
      {
         return isPlanet;
      };
      
      
      [Bindable(event="willNotChange")]
      public function get terrainType() : int
      {
         if (isPlanet)
         {
            return TerrainType.getType(variation);
         }
         throw new IllegalOperationError("Location is not a PLANET. Therefore it is illegal " +
            "to read [prop terrainType]");
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
            
            case LocationType.PLANET:
               imageName = AssetNames.getPlanetImageName(planetClass, variation);
               break;
            
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
            
            case LocationType.PLANET:
               var p:Planet = new Planet();
               p.id = id;
               p.solarSystemId = solarSystemId;
               
               // This might be true as well as a temporary hack.
               // The latter is more probable so change this to something else
               p.playerId = ModelLocator.getInstance().player.id;
               
               if (zoomObj != null)
               {
                  navCtrl.selectBuilding(zoomObj);
               }
               else
               {
                  navCtrl.toPlanet(p);
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