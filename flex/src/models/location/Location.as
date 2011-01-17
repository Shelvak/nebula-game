package models.location
{
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import interfaces.ICleanable;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.galaxy.Galaxy;
   import models.location.events.LocationEvent;
   import models.map.MMapSpace;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.solarsystem.SolarSystem;
   import models.tile.TerrainType;
   
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   
   import utils.Localizer;
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.datastructures.Collections;
   
   
   
   /**
    * Dispatched when <code>isNavigable</code> property changes.
    * 
    * @eventType models.location.events.LocationEvent.IS_NAVIGABLE_CHANGE
    */
   [Event(name="isNavigableChange", type="models.location.events.LocationEvent")]
   
   
   public class Location extends LocationMinimal implements ICleanable
   {
      private var _ssObject:MSSObject = new MSSObject();
      
      
      public function Location()
      {
         super();
      }
      
      
      public function cleanup() : void
      {
         type = LocationType.GALAXY;
      }
      
      
      [Optional]
      [Bindable]
      public override function set type(value:uint) : void
      {
         if (super.type != value)
         {
            typeChanging(value);
            super.type = value;
         }
      }
      
      
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
      };
      
      
      /* ########################################## */
      /* ### NAVIGATE_TO AND IS_NAVIGABLE LOGIC ### */
      /* ########################################## */
      
      
      [Bindable(event="isNavigableChange")]
      /**
       * Indicates if player can navigate to (open) this location.
       */
      public function get isNavigable() : Boolean
      {
         return isGalaxy ||
                isSolarSystem && ML.latestGalaxy.getSSById(id) ||
                isSSObject && ML.latestGalaxy.getSSById(solarSystemId);
      }
      
      
      /**
       * Navigates to this location. You must make sure that <code>isNavigable</code> returns
       * <code>true</code> before calling this method or it will fail. This method does not support
       * locations of <code>LocationType.BUILDING</code> and <code>LocationType.UNIT</code> types and
       * will fail if called on a location instance of such type
       */
      public function navigateTo(zoomObj:* = void) : void
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
            
            case LocationType.SS_OBJECT
               if (zoomObj == null)
               {
                  var planet:MSSObject;
                  palnet = Collections.findFirst(ML.player.planets,
                     function(planet:MSSObject) : Boolean
                     {
                        return planet.id == id;
                     }
                  );
                  if (planet)
                  {
                     navCtrl.toPlanet(planet);
                  }
                  else
                  {
                     var solarSystem:SolarSystem = ML.latestGalaxy.getSSById(solarSystemId)
                     if (solarSystem)
                     {
                        if (ML.latestSolarSystem && ML.latestSolarSystem.id == solarSystemId)
                        {
                           planet = ML.latestSolarSystem.getSSObjectById(id);
                           if (planet.viewable)
                           {
                              navCtrl.toPlanet(planet);
                           }
                           else
                           {
                              navCtrl.toSolarSystem(solarSystemId);
                           }
                        }
                        else
                        {
                           navCtrl.toSolarSystem(solarSystemId);
                        }
                     }
                     else
                     {
                        throw new IllegalOperationError("Unable to navigate to " + this + ": solar " +
                                                        "system with id " + solarSystemId + " is not " +
                                                        "in the galaxy");
                     }
                  }
               }
               else
               {
                  if (zoomObj is Building)
                  {
                     navCtrl.selectBuilding(zoomObj);
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
      
      
      private function typeChanging(typeNew:int) : void
      {
         var typeOld:int = type;
         // unregister any event listeners
         if (typeOld == LocationType.SOLAR_SYSTEM || typeOld == LocationType.SS_OBJECT)
         {
            removeMapObjectsEventHandlers(_lastGalaxy);
            removeMapObjectsEventHandlers(_lastSolarSystem);
            removeModelLocatorEventHandlers();
            if (typeOld == LocationType.SS_OBJECT)
            {
               ML.player.planets.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                     playerPlanets_collectionChangeHandler);
            }
         }
         // register new event listeners
         if (typeNew == LocationType.SOLAR_SYSTEM || typeNew == LocationType.SS_OBJECT)
         {
            _lastGalaxy = ML.latestGalaxy;
            _lastSolarSystem = ML.latestSolarSystem;
            addMapObjectsEventHandlers(_lastGalaxy);
            addMapObjectsEventHandlers(_lastSolarSystem);
            addModelLocatorEventHandlers();
            if (typeNew == LocationType.SS_OBJECT)
            {
               ML.player.planets.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                  playerPlanets_collectionChangeHandler);
            }
         }
         dispatchIsNavigableChangeEvent();
      }
      
      
      private function playerPlanets_collectionChangeHandler(event:CollectionEvent) : void
      {
         dispatchIsNavigableChangeEvent();
      }
      
      
      /* ////////////////////////////////////////////////////////////////// */
      /* /// We listen for latest galaxy and latest solar system change /// */
      /* ////////////////////////////////////////////////////////////////// */
      private var _lastGalaxy:MMapSpace;
      private var _lastSolarSystem:MMapSpace;
      private function addModelLocatorEventHandlers() : void
      {
         ML.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, modelLocator_propertyChangeHandler);
      }
      private function removeModelLocatorEventHandlers() : void
      {
         ML.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, modelLocator_propertyChangeHandler);
      }
      private function modelLocator_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == "latestGalaxy" || event.property == "latestSolarSystem")
         {
            removeMapObjectsEventHandlers(_lastGalaxy);
            removeMapObjectsEventHandlers(_lastSolarSystem);
            if (event.property == "latestGalaxy")
            {
               _lastGalaxy = ML.latestGalaxy;
            }
            else
            {
               _lastSolarSystem = ML.latestSolarSystem;
            }
            addMapObjectsEventHandlers(_lastGalaxy);
            addMapObjectsEventHandlers(_lastSolarSystem);
         }
      }
      
      
      /* /////////////////////////////////////////////////////////////////////////// */
      /* /// We listen only for changes in natural objects list of the space map /// */
      /* /////////////////////////////////////////////////////////////////////////// */
      private function addMapObjectsEventHandlers(map:MMapSpace) : void
      {
         if (map == null)
         {
            return;
         }
         map.naturalObjects.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                             mapObjects_collectionChangeHandler);
      }
      private function removeMapObjectsEventHandlers(map:MMapSpace) : void
      {
         if (map == null)
         {
            return;
         }
         map.naturalObjects.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                mapObjects_collectionChangeHandler);
      }
      private function mapObjects_collectionChangeHandler(event:CollectionEvent) : void
      {
         dispatchIsNavigableChangeEvent();
      }
      
      
      private function dispatchIsNavigableChangeEvent() : void
      {
         if (hasEventListener(LocationEvent.IS_NAVIGABLE_CHANGE))
         {
            dispatchEvent(new LocationEvent(LocationEvent.IS_NAVIGABLE_CHANGE));
         }
      }
      
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Shortcut for <code>Localizer.string("Location", resourceName, parameters)</code>.
       */
      private function getString(resourceName:String, parameters:Array = null) : String
      {
         return Localizer.string("Location", resourceName, parameters);
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