package models.location
{
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import models.building.Building;
   import models.map.MMap;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.solarsystem.SolarSystem;
   import models.tile.TerrainType;
   
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   
   public class Location extends LocationMinimal
   {
      private static function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      public function Location() {
         super();
      }
      
      
      [Optional]
      public var terrain:int = TerrainType.GRASS;
      [Optional]
      public var name:String = null;
      [Optional]
      [Bindable]
      public var player:PlayerMinimal;
      [Optional]
      public var solarSystemId:int = 0;
      [Optional]
      public var ssObjectType:String = SSObjectType.PLANET;
      
      public function get inBattleground() : Boolean {
         return isSSObject && ML.latestGalaxy.isBattleground(solarSystemId);
      }
      
      private var _variation:int;
      [Bindable(event="willNotChange")]
      public function set variation(value:int) : void {
         if (_variation != value)
            _variation = value;
      }
      public function get variation() : int {
         if (isSSObject)
            return MSSObject.getVariation(id, ssObjectType, terrain);
         return _variation;
      }
      
      [Bindable(event="willNotChange")]
      public function get solarSystemName() : String {
         if (isBattleground || inBattleground)
            return Localizer.string("Galaxy", "label.wormhole");
         if (isMiniBattleground || isSSObject && ML.latestGalaxy.getSSById(solarSystemId).isMiniBattleground)
            return Localizer.string("Galaxy", "label.pulsar", [solarSystemId]);
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
         if (isGalaxy)
         {
            return getString("description.short.galaxy");
         }
         if (isSolarSystem)
         {
            if (isBattleground)
            {
               return solarSystemName;
            }
            return getString("description.short.solarSystem", [solarSystemName]);
         }
         if (isSSObject)
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
               if (isBattleground)
                  return solarSystemName;
               return getString("description.long.solarSystem", [solarSystemName, x, y]);
               
            case LocationType.SS_OBJECT:
               if (inBattleground)
                  return getString("description.long.planetInBattleground", [planetName]);
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
               if (isBattleground)
               {
                  imageName = AssetNames.WORMHOLE_IMAGE_NAME;
               }
               else
               {
                  imageName = AssetNames.getSSImageName(variation);
               }
               break;
            
            case LocationType.SS_OBJECT:
               return MSSObject.getImageData(id, ssObjectType, terrain);
            
            default:
               throwUnsupportedLocationTypeError();
         }
         return IMG.getImage(imageName);
      };
      
      
      /* ########################################## */
      /* ### NAVIGATE_TO AND IS_NAVIGABLE LOGIC ### */
      /* ########################################## */
      
      
      /**
       * Indicates if player can navigate to (open) this location.
       */
      public function get isNavigable() : Boolean
      {
         if (isGalaxy)
         {
            return true;
         }
         if (isSolarSystem)
         {
            if (ML.latestGalaxy.getSSById(id) != null ||
               (ML.latestGalaxy.isWormhole(id) || ML.latestGalaxy.isBattleground(id) &&
                                                  ML.latestGalaxy.hasWormholes))
            {
               return true;
            }
         }
         if (isSSObject)
         {
            var playerPlanet:MSSObject = findPlayerPlanet();
            if (playerPlanet != null)
            {
               return true;
            }
            if (ML.latestGalaxy.getSSById(solarSystemId) != null ||
                ML.latestGalaxy.isBattleground(solarSystemId) && ML.latestGalaxy.hasWormholes)
            {
               return true;
            }
         }
         return false
      }
      
      
      /**
       * Navigates to this location. You must make sure that <code>isNavigable</code> returns
       * <code>true</code> before calling this method or it will fail. This method does not support
       * locations of <code>LocationType.BUILDING</code> and <code>LocationType.UNIT</code> types and
       * will fail if called on a location instance of such type. Currently <code>zoomObj</code> can only
       * be instance of <code>Building</code>.
       */
      public function navigateTo(zoomObj:* = null) : void
      {
         var thisLoc:Location = this;
         switch(type)
         {
            case LocationType.GALAXY:
               NAV_CTRL.toGalaxy(null,
                  function() : void
                  {
                     ML.latestGalaxy.moveTo(thisLoc);
                  }
               );
               break;
            
            case LocationType.SOLAR_SYSTEM:
               NAV_CTRL.toSolarSystem(id, 
                  function() : void
                  {
                     ML.latestSolarSystem.moveTo(thisLoc);
                  }
               );
               break;
            
            case LocationType.SS_OBJECT:
               if (zoomObj == null)
               {
                  var planet:MSSObject;
                  planet = findPlayerPlanet();
                  if (planet != null)
                  {
                     NAV_CTRL.toPlanet(planet);
                  }
                  else if (ML.latestPlanet != null && ML.latestPlanet.id == id)
                  {
                     NAV_CTRL.toPlanet(ML.latestPlanet.ssObject);
                  }
                  else
                  {
                     var solarSystem:SolarSystem = ML.latestGalaxy.getSSById(solarSystemId);
                     if (solarSystem == null)
                     {
                        if (ML.latestGalaxy.isWormhole(solarSystemId) || 
                            ML.latestGalaxy.isBattleground(solarSystemId) && ML.latestGalaxy.hasWormholes)
                        {
                           solarSystem = ML.latestGalaxy.wormholes[0];
                        }
                     }
                     if (solarSystem != null)
                     {
                        if (ML.latestSolarSystem != null && !ML.latestSolarSystem.fake)
                        {
                           if (ML.latestSolarSystem.id == solarSystemId ||
                               ML.latestSolarSystem.isGlobalBattleground && (ML.latestGalaxy.isBattleground(solarSystemId) ||
                                                                             ML.latestGalaxy.isWormhole(solarSystemId)))
                           {
                              planet = ML.latestSolarSystem.getSSObjectById(id);
                              if (planet.viewable)
                              {
                                 NAV_CTRL.toPlanet(planet);
                              }
                              else
                              {
                                 navigateToSolarSystem(solarSystem.id);
                              }
                           }
                           else
                           {
                              navigateToSolarSystem(solarSystem.id);
                           }
                        }
                        else
                        {
                           navigateToSolarSystem(solarSystem.id);
                        }
                     }
                     else
                     {
                        throw new IllegalOperationError("Unable to navigate to " + this + ": solar " +
                                                        "system with id " + solarSystemId + " is not " +
                                                        "in the visible part of the galaxy");
                     }
                  }
               }
               else
               {
                  if (zoomObj is Building)
                  {
                     NAV_CTRL.selectBuilding(zoomObj);
                  }
                  else
                  {
                     throw new ArgumentError("Only instances of Building are currently supported " +
                                             "for [param zoomObj]");
                  }
               }
               break;
            
            default:
               throw new IllegalOperationError("Locations of LocationType.BUILDING and LocationType.UNIT " +
                                               "type does not support this method");
         }
      }
      private function navigateToSolarSystem(ssId:int) : void {
         NAV_CTRL.toSolarSystem(ssId,
            function() : void {
               ML.latestSolarSystem.moveTo(ML.latestSolarSystem.getSSObjectById(id).currentLocation);
            }
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      /**
       * Looks for a planet in <code>ML.player.planets</code> with the same ID as <code>Location.id</code>.
       */
      private function findPlayerPlanet() : MSSObject {
         return Collections.findFirst(ML.player.planets, filterFunction_playerPlanet);
      }
      private function filterFunction_playerPlanet(planet:MSSObject) : Boolean {
         return planet.id == id;
      }
      
      private function getString(resourceName:String, parameters:Array = null) : String {
         return Localizer.string("Location", resourceName, parameters);
      }
      
      private function throwUnsupportedLocationTypeError() : void {
         throw new Error("Unsupported location type: " + type);
      }
   }
}