package models.planet
{
   import config.Config;
   
   import controllers.folliages.PlanetFolliagesAnimator;
   import controllers.objects.ObjectClass;
   
   import flash.display.BitmapData;
   
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Player;
   import models.building.Building;
   import models.building.BuildingBonuses;
   import models.folliage.BlockingFolliage;
   import models.folliage.Folliage;
   import models.folliage.NonblockingFolliage;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.planet.events.PlanetEvent;
   import models.tile.TerrainType;
   import models.tile.Tile;
   import models.tile.TileKind;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.PropertyChangeEvent;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Dispatched when owner of the planet has changed.
    * 
    * @eventType models.planet.events.PlanetEvent.OWNER_CHANGE
    */
   [Event(name="ownerChange", type="models.planet.events.PlanetEvent")]
   
   /**
    * Dispatched when an object has been added to this planet.
    * 
    * @eventType models.planet.events.PlanetEvent.OBJECT_ADD
    */
   [Event(name="objectAdd", type="models.planet.events.PlanetEvent")]
   
   /**
    * Dispatched when an object has been removed from this planet.
    * 
    * @eventType models.planet.events.PlanetEvent.OBJECT_REMOVE
    */
   [Event(name="objectRemove", type="models.planet.events.PlanetEvent")]
   
   
   [Bindable]
   public class Planet extends Map
   {
      /**
       * Original width of a planet image.
       */
      public static const IMAGE_WIDTH: Number = 200;
      
      /**
       * Original height of a planet image.
       */
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      
      
      private var _zIndexCalculator:ZIndexCalculator = null;
      
      
      private var _folliagesAnimator:PlanetFolliagesAnimator = null;
      private var _suppressFolliagesAnimatorUpdate:Boolean = false;
      private function updateFolliagesAnimator() : void
      {
         if (_suppressFolliagesAnimatorUpdate)
         {
            return;
         }
         _folliagesAnimator.setFolliages(nonblockingFolliages);
      }
      
      
      /**
       * Constructor.
       */
      public function Planet()
      {
         super();
         _zIndexCalculator = new ZIndexCalculator(this);
         _folliagesAnimator = new PlanetFolliagesAnimator();
         initMatrices();
      }
      
      
      public function cleanup() : void
      {
         if (_zIndexCalculator)
         {
            _zIndexCalculator = null;
         }
         if (_folliagesAnimator)
         {
            _folliagesAnimator.cleanup();
            _folliagesAnimator = null;
         }
      }
      
      
      [Required]
      /**
       * Id of the solar system this planet belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 0
       */
      public var solarSystemId:int = 0;
      
      
      [Required]
      /**
       * Name of the planet.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default empty string
       */ 
      public var name:String = "";
      
      
      private var _playerId:int = Player.FORMER_PLAYER_ID;
      [Required]
      [Bindable(event="planetOwnerChange")]
      /**
       * Id of the player this planet belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable(event="planetOwnerChange")]</i></p>
       * 
       * @default Player.FORMER_PLAYER_ID
       */
      public function set playerId(value:int) : void
      {
         if (_playerId != value)
         {
            _playerId = value;
            dispatchOwnerChangeEvent();
            dispatchPropertyUpdateEvent("playerId", value);
            dispatchPropertyUpdateEvent("isOwned", isOwned);
            dispatchPropertyUpdateEvent("isOwnedByCurrent", isOwnedByCurrent);
         }
      }
      /**
       * @private
       */
      public function get playerId() : int
      {
         return _playerId;
      }
      
      
      [Optional]
      /**
       * Player that owns this planet. This is only for additional information only. If you need player id, use
       * <code>playerId</code> property.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default null
       */
      public var player:Player = null;
      
      
      /**
       * Location of a planet.
       * 
       * @see models.planet.PlanetLocation 
       */
      public var location:PlanetLocation = new PlanetLocation();
      
      
      /**
       * Location of a planet.
       */
      public function get currentLocation() : LocationMinimal
      {
         var loc:LocationMinimal = new LocationMinimal();
         var locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(loc);
         locWrapper.type = LocationType.SOLAR_SYSTEM;
         locWrapper.id = solarSystemId;
         locWrapper.angle = location.angle;
         locWrapper.position = location.position;
         return loc;
      }
      
      
      private var _width:int = 0;
      /**
       * Width of the planet's map in tiles.
       * 
       * @default 1
       */
      [Required]
      public function set width (value:int) : void
      {
         _width = value;
         initMatrices();
      }
      /**
       * @private 
       */
      public function get width() : int
      {
         return _width;
      }
      
      
      private var _height:int = 0;
      /**
       * Height of the planet's map in tiles.
       * 
       * @default 1
       */
      [Required]
      public function set height(v:int) : void
      {
         _height = v;
         initMatrices();
      }
      /**
       * @private 
       */
      public function get height() :int
      {
         return _height;
      }
      
      
      [Required]
      /**
       * Variation of an icon that visualizes a planet in a solar system.
       * 
       * @default 1
       */      
      public var variation:int = 1;
      
      
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Class of the planet.
       * 
       * @default PlanetClass.LANDABLE 
       */      
      public var planetClass:String = PlanetClass.LANDABLE;
      
      
      [Bindable(event="willNotChange")]
      public function get isLandable() : Boolean
      {
         return planetClass == PlanetClass.LANDABLE;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get isJumpgate() : Boolean
      {
         return planetClass == PlanetClass.JUMPGATE;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Image of a planet.
       */
      public function get imageData() : BitmapData
      {
         return ImagePreloader.getInstance().getImage(AssetNames.getPlanetImageName(planetClass, variation));
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Terrain type of this planet (TerrainType.GRASS, TerrainType.DESERT
       * or TerrainType.MUD).
       */
      public function get terrainType() : int
      {
         return TerrainType.getType(variation);
      }
      
      
      /**
       * Type of a planet.
       * 
       * @default PlanetType.REGULAR
       */
      public var type: String = PlanetType.REGULAR;
      
      
      [Required]
      /**
       * Size of the planet image in the solar system map compared with original image
       * dimentions in percents.
       * 
       * @default 100 percent
       */ 
      public var size: Number = 100;
      
      
      [Required]
      public var metalRate: int = 0;
      [Required]
      public var energyRate: int = 0;
      [Required]
      public var zetiumRate: int = 0;
      
      
      public function toLocation(): Location
      {
         var tempLocation: Location = new Location();
         tempLocation.variation = variation;
         tempLocation.name = name;
         tempLocation.playerId = playerId;
         tempLocation.solarSystemId = solarSystemId;
         tempLocation.type = LocationType.PLANET;
         tempLocation.x = location.position;
         tempLocation.y = location.angle;
         tempLocation.id = id;
         return tempLocation;
      }
      
      /**
       * Determines and returns status of the planet. Available status values
       * are defined in <code>PlanetStatus</code> class. Currently only OWNED,
       * ENEMY and NEUTRAL are supported.
       *  
       * @param currentPlayerId Id of current player.
       * @return status of the planet.
       */ 
      public function getStatus (currentPlayerId: int) :String
      {
         if (playerId == 0)
         {
            return PlanetStatus.NEUTRAL;
         }
         else if (playerId == currentPlayerId)
         {
            return PlanetStatus.OWNED;
         }
         else
         {
            return PlanetStatus.ENEMY;
         }
      }
      
      
      /**
       * Indicates if a planet is owned by someone.
       * 
       * @default false 
       */
      [Bindable(event="planetOwnerChange")]
      public function get isOwned () :Boolean
      {
         return playerId != Player.NO_PLAYER_ID;
      }
      
      
      /**
       * True means that this planet belongs to the current player.
       * 
       * @default false 
       */      
      [Bindable(event="planetOwnerChange")]
      public function get isOwnedByCurrent () :Boolean
      {
         return isOwned && ModelLocator.getInstance().player.id == playerId;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int
      {
         return MapType.PLANET;
      };
      
      
      public override function getLocation(x:int, y:int) : Location
      {
         return toLocation();
      }
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.PLANET;
      }
      
      
      public override function definesLocation(location:LocationMinimal) : Boolean
      {
         return location.isPlanet && location.id == id;
      }
      
      
      /**
       * Two-dimentional array containing tiles of this planet. Regular tiles are represented
       * with null values.
       * 
       * @default <code>null</code>
       */
      protected var tilesMatrix:Array = null;
      
      
      /**
       * Two-dimenstional array containing objects on this planet. One object may occupy more than
       * one tile so all tiles under such object will refrerence the same instance.
       */
      protected var objectsMatrix:Array = null;
      /**
       * List of all objects on the planet. This list could be constructed from <code>objectsMatrix</code>
       * however that would be very inefficient in terms of performance.
       */
      protected var objectsList:ArrayCollection = new ArrayCollection();
      
      
      private function initMatrices() :void
      {
         if (width == 0 || height == 0)
         {
            tilesMatrix = null;
            objectsMatrix = null;
            return;
         }
         
         tilesMatrix = [];
         objectsMatrix = [];
         for (var i:int = 0; i < width; i++)
         {
            var objsCol:Array = [];
            var tilesCol:Array = [];
            for (var j:int = 0; j < height; j++)
            {
               objsCol.push(null);
               tilesCol.push(null);
            }
            objectsMatrix.push(objsCol);
            tilesMatrix.push(tilesCol);
         }
      }
      
      
      /* ############# */
      /* ### TILES ### */
      /* ############# */
      
      
      /**
       * Adds a given tile to this planet to appropriate cell in tiles array.
       * 
       * @param t A tile that needs to be added to this planet.
       */
      public function addTile(t:Tile) :void
      {
         tilesMatrix[t.x][t.y] = t;
      }
      
      
      /**
       * Removes a tile form this planet if one is found.
       * 
       * @param t A tile to be removed form the planet.
       */
      public function removeTile(t:Tile) :void
      {
         if (tilesMatrix[t.x][t.y] == t)
         {
            tilesMatrix[t.x][t.y] = null;
         }
      }
      
      
      /**
       * Returns <code>Tile</code> object in the given coordinates.
       * 
       * @param x
       * @param y
       * 
       * @return instance of <code>Tile</code> or <code>null</code> if there is no tile (regular tile)
       * in the given coordinates.
       */      
      public function getTile(x:int, y:int) : Tile
      {
         return tilesMatrix[x][y];
      }
      
      
      private var _resourceTiles:ArrayCollection;
      /**
       * List of all non-fake resource tiles.
       */
      public function get resourceTiles() : ArrayCollection
      {
         if (!_resourceTiles)
         {
            _resourceTiles = new ArrayCollection();
            for (var x:int = 0; x < width; x++)
            {
               for (var y:int = 0; y < height; y++)
               {
                  var t:Tile = tilesMatrix[x][y];
                  if (t && t.isResource() && !t.fake)
                  {
                     _resourceTiles.addItem(t);
                  }
               }
            }
         }
         return _resourceTiles;
      }
      
      
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      
      private var _suppressZIndexCalculation:Boolean = false;
      /**
       * Recalculates <code>zIndex</code> value of all objects on the planet.
       * This method is called each time new object is added to the planet.
       * However, if you set <code>suppressZIndexCalculation</code> to <code>true</code> the
       * method will return immediately and will not perform any calculations. This should
       * be done when a batch of objects are about to be added because <code>zIndex</code>
       * calculation takes some time to finish. After all objects have been added you must
       * set <code>suppressZIndexCalculation</code> to <code>false</code> and call
       * <code>calculateZIndex()</code> manually.
       */
      protected function calculateZIndex() : void
      {
         if (_suppressZIndexCalculation)
         {
            return;
         }
         _zIndexCalculator.calculateZIndex();
      }
      
      
      public override function get objects() : ArrayCollection
      {
         return objectsList;
      }
      
      
      /**
       * Returns an object that occupies the give tile.
       * 
       * @param x X coordinate of a tile
       * @param y Y coordinate if a tile
       * 
       * @return <code>PlanetObject</code> that stands on a tile with given coordiantes
       * or <code>null</code> if there is no object there.
       */
      public function getObject(x:int, y:int) : PlanetObject
      {
         return objectsMatrix[x][y] as PlanetObject;
      }
      
      
      /**
       * Returns new filtered objects collection.
       * 
       * @param filterFunction A function that will be used to determine if
       * and object should be included in the collection. For more information
       * on this parameter see <code>ArrayCollection.filterFunction</code>.
       * 
       * @return New collection with item for which <code>filterFunction</code>
       * has returned <code>true</code>.
       * 
       * @see mx.collections.ArrayCollection#filterFunction
       */
      public function filterObjects(filterFunction:Function) : ArrayCollection
      {
         var list:ArrayCollection = new ArrayCollection(objects.source);
         list.filterFunction = filterFunction;
         list.refresh();
         return list;
      }
      
      
      /**
       * List of all blocking objects on this planet.
       */
      public function get blockingObjects() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return (item as PlanetObject).isBlocking;
            }
         );
      }
      
      
      /**
       * List of all buildings on the planet.
       */
      public function get buildings() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return item is Building;
            }
         );
      }
      
      /* ############# */
      /* ### UNITS ### */
      /* ############# */
      
      [ArrayElementType ("models.unit.Unit")]
      [Optional]
      public var units: ModelsCollection = new ModelsCollection();
      
      /**
       * Looks for and returns a unit with a given id.
       * 
       * @param id Id of a unit.
       * 
       * @return <code>Unit</code> instance with a given id or <code>null</code>
       * if one can't be found.
       */
      [Bindable(event="unitUpgradeStarted")]
      public function getUnitById(id: int): Unit
      {
         for each (var element: Unit in units)
         {
            if (element.id == id)
               return element;
         }
         return null;
      }
      
      [Bindable(event="unitRefresh")]
      public function getActiveUnits(): ArrayCollection
      {
         var activeUnits: ArrayCollection = new ArrayCollection();
         for each (var unit: Unit in units)
         {
            if (unit.level > 0)
               activeUnits.addItem(unit);
         }
         return activeUnits;
      }
      
      [Bindable(event="unitRefresh")]
      public function getActiveGroundUnits(): ArrayCollection
      {
         var activeUnits: ArrayCollection = new ArrayCollection();
         for each (var unit: Unit in units)
         {
            if ((unit.level > 0) && (unit.kind == UnitKind.GROUND))
               activeUnits.addItem(unit);
         }
         return activeUnits;
      }
      
      [Bindable(event="unitRefresh")]
      public function getActiveStorableGroundUnits(): ArrayCollection
      {
         var storableUnits: ArrayCollection = new ArrayCollection();
         for each (var unit: Unit in units)
         {
            if ((unit.level > 0) && (unit.kind == UnitKind.GROUND) && unit.volume > 0)
               storableUnits.addItem(unit);
         }
         return storableUnits;
      }
      
      
      [Bindable (event = "planetBuildingUpgraded")]
      public function getUnitsFacilities(): ArrayCollection
      {
         var facilities : ArrayCollection = new ArrayCollection();
         var constructors: Array = Config.getConstructors(ObjectClass.UNIT);
         for each (var element: Building in buildings){
            if ((constructors.indexOf(element.type) != -1) && (element.state != 0))
            {
               facilities.addItem(element);
            }
         }
         facilities.sort = new Sort();
         facilities.sort.fields = [new SortField('constructablePosition', false, false, true)];
         facilities.refresh();
         return facilities;
      }
      
      
      /**
       * Lis of all folliages on the planet.
       */
      public function get folliages() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return item is Folliage;
            }
         );
      }
      
      
      /**
       * List of all blocking folliages on the planet.
       */
      public function get blockingFolliages() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return item is BlockingFolliage;
            }
         );
      }
      
      
      /**
       * List of all non-blocking folliages on the planet.
       */
      public function get nonblockingFolliages() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return item is NonblockingFolliage;
            }
         );
      }
      
      
      /**
       * Adds <code>PlanetObject</code> to the planet and dispatches
       * <code>PlanetEvent.OBJECT_ADD</code> event.
       * 
       * @param object An object that needs to be added
       * @param list List to which the given object must be added
       * 
       * @throws Error if another object occupies the same space as the given one
       */
      public function addObject(object:PlanetObject) : void
      {
         // Check if there are no objects in the same place
         var mapObjects:ArrayCollection = getObjectsInArea(object.x, object.xEnd, object.y, object.yEnd);
         if (mapObjects.length != 0)
         {
            throw new Error(
               "Can't add object to the planet (id: " + id + "): another object occupies the " +
               "same space! (x: " + object.x + " to " + object.xEnd + ", y: " + object.y + " to " +
               object.yEnd + ")\n\nMap objects:" + mapObjects.source.join("\n")
            );
         }
         
         for (var x:int = object.x; x <= object.xEnd; x++)
         {
            for (var y:int = object.y; y <= object.yEnd; y++)
            {
               objectsMatrix[x][y] = object;
            }
         }
         objectsList.addItem(object);
         calculateZIndex();
         updateFolliagesAnimator();
         dispatchObjectAddEvent(object);
      }
      
      
      /**
       * Adds all objects to this planet. <code>PlanetEvent.OBJECT_ADD</code> event is suppressed during
       * this operation.
       * 
       * @param objects collection of <code>PlanetObject<code>s to add to this planet.
       * 
       * @see #addObject()
       */
      public function addAllObjects(objects:ArrayCollection) : void
      {
         _suppressObjectAddEvent = true;
         _suppressZIndexCalculation = true;
         _suppressFolliagesAnimatorUpdate = true;
         for each (var object:PlanetObject in objects)
         {
            addObject(object);
         }
         _suppressObjectAddEvent = false;
         _suppressZIndexCalculation = false;
         _suppressFolliagesAnimatorUpdate = false;
         calculateZIndex();
         updateFolliagesAnimator();
      }
      
      
      /**
       * Removes <code>PlanetObject<code> from the planet and dispatches
       * <code>PlanetEvent.OBJECT_REMOVE</code> event if the object has actually been removed.
       * 
       * @param object An object that needs to be removed
       * 
       * @throws Error if <code>object</code> is <code>null</code>
       */
      public function removeObject(object:PlanetObject) : void
      {
         if (object == null)
         {
            throw new Error("object must be valid instance of PlanetObject");
         }
         var x:int = object.x;
         var y:int = object.y;
         if (objectsMatrix[x][y] == object)
         {
            for (x = object.x; x <= object.xEnd; x++)
            {
               for (y = object.y; y <= object.yEnd; y++)
               {
                  objectsMatrix[x][y] = null;
               }
            }
            objectsList.removeItemAt(objectsList.getItemIndex(object));
            dispatchObjectRemoveEvent(object);
         }
      }
      
      
      /**
       * Looks for and returns a building with a given id.
       * 
       * @param id Id of a building.
       * 
       * @return <code>Building</code> instance with a given id or <code>null</code>
       * if one can't be found.
       */
      public function getBuildingById(id:int) : Building
      {
         for each (var b:Building in buildings)
         {
            if (b.id == id)
            {
               return b;
            }
         }
         return null;
      }
      
      
      /**
       * Looks for and returns a constructor which currently is constructing a constructable with
       * a given id.
       * 
       * @param id Id of a building or unit beeing constructed.
       * 
       * @return <code>Building</code> instance which is currently constructing the given
       * constructable or <code>null</code> if one can't be found.
       */
      public function getBuildingByConstructable(id:int, type: String) : Building
      {
         for each (var b:Building in buildings)
         {
            if ((b.isConstructor(type)) && (b.constructableType != null))
            {
               if (b.constructableId == id)
                  return b;
            }
         } 
         return null;
      }
      
      
      /**
       * Lets you find out if there are buildings in the given area on the map.
       *  
       * @param xMin
       * @param xMax
       * @param yMin
       * @param yMax
       * @param skip A building that should be skiped while checking the area.
       * 
       * @return <code>true</code> if there is at least one building in the given area or
       * <code>false</code> otherwise.
       */
      public function buildingsInAreaExist(xMin:int, xMax:int, yMin:int, yMax:int, skip:Building=null) : Boolean
      {
         for each (var object:Object in getObjectsInArea(xMin, xMax, yMin, yMax))
         {
            if (object is Building && object != skip)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * Lets you find out if there are blocking folliages in the given area on the map.
       *  
       * @param xMin
       * @param xMax
       * @param yMin
       * @param yMax
       * 
       * @return <code>true</code> if there is at least one blocking folliage in the given area or
       * <code>false</code> otherwise.
       */
      public function blockingFolliagesInAreaExist(xMin:int, xMax:int, yMin:int, yMax:int) : Boolean
      {
         for each (var object:Object in getObjectsInArea(xMin, xMax, yMin, yMax))
         {
            if (object is BlockingFolliage)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * Determines if any buildings in given building's area exist.
       * 
       * @param building Building to be examinded.
       * 
       * @return <code>true</code> if there are at least one building in the
       * area of the given bulding or <code>false</code> otherwise.
       */
      public function buildingsAroundExist(building:Building) : Boolean
      {
         var gap:int = Building.GAP_BETWEEN;
         return buildingsInAreaExist(
            building.x - gap, building.xEnd + gap,
            building.y - gap, building.yEnd + gap,
            building
         );
      }
      
      
      /**
       * Determines if any blocking folliages in given building basment's area exist.
       * 
       * @param building Building to be examinded.
       * 
       * @return <code>true</code> if there are at least one blocking folliage in the basement
       * area of the given bulding or <code>false</code> otherwise.
       */
      public function blockingFolliagesUnderExist(building:Building) : Boolean
      {
         return blockingFolliagesInAreaExist(
            building.x, building.xEnd,
            building.y, building.yEnd
         );
      }
      
      
      /**
       * Returs list of objects in the given area. If no objects are present in
       * the given area, empty list is returned.
       * 
       * @param xMin
       * @param xMax
       * @param yMin
       * @param yMax
       * 
       * @return List of objects in the given area or empty array if no such
       * objects exist
       */
      public function getObjectsInArea(xMin:int, xMax:int, yMin:int, yMax:int) : ArrayCollection
      {
         xMin = xMin < 0 ? 0 : xMin;
         yMin = yMin < 0 ? 0 : yMin;
         xMax = xMax >= width  ? width  - 1 : xMax;
         yMax = yMax >= height ? height - 1 : yMax;
         var list:ArrayCollection = new ArrayCollection();
         for (var x:int = xMin; x <= xMax; x++)
         {
            for (var y:int = yMin; y <= yMax; y++)
            {
               var object:Object = objectsMatrix[x][y];
               if (object && !list.contains(object))
               {
                  list.addItem(object);
               }
            }
         }
         return list;
      }
      
      
      /**
       * Determines if the given building would be on the map with it's whole ground.
       * This method lets examine buildings that are not part of this map yet.
       *  
       * @param building A building to examine.
       * 
       * @return <code>true</code> if the building would be on the map, <code>false</code>
       * if at least one building tile would not be on the map. 
       */
      public function isBuildingOnMap(building:Building) : Boolean
      {
         return building.x >= 0 && building.y >= 0 &&
            building.xEnd < width && building.yEnd < height;
      } 
      
      
      /**
       * Determines if a given building migth occupy restricted tiles.
       *  
       * @param building
       * 
       * @return <code>true</code> if the given building might occupy tiles that
       * it could not be built on or <code>false</code> otherwise.
       */      
      public function restrTilesUnderBuildingExist(building:Building) : Boolean
      {
         for (var x:int = building.x; x <= building.xEnd; x++)
         {
            for (var y:int = building.y; y <= building.yEnd; y++)
            {
               var t:Tile = getTile(x, y);
               if (building.isTileRestricted(t ? t.kind : TileKind.REGULAR))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      
      /**
       * Returns an array of tiles under the given building. If a building can't
       * be built in its current position, empty array is returned.
       *  
       * @param building A building (might not be part of this map).
       * 
       * @return Array ot tiles under the building. Elements in the array are integers
       * from <code>TileKind</code> class.
       */      
      public function getTilesUnderBuilding(building:Building) : Array
      {
         if (!canBeBuilt(building))
         {
            return [];
         }
         var result:Array = [];
         for (var x:int = building.x; x <= building.xEnd; x++)
         {
            for (var y:int = building.y; y <= building.yEnd; y++)
            {
               var t:Tile = getTile(x, y);
               result.push(t ? t.kind : TileKind.REGULAR);
            }
         }
         return result;
      }
      
      
      /**
       * Use this method to find out if a building can be built in its current position.
       *  
       * @param b A building that is about to be built
       * @return <code>true</code> if a building can be built or <code>false</code>
       * otherwise.
       */
      public function canBeBuilt(building:Building) : Boolean
      {
         if (isBuildingOnMap(building) &&
            !restrTilesUnderBuildingExist(building) &&
            !buildingsAroundExist(building) &&
            !blockingFolliagesUnderExist(building))
         {
            return true;
         }
         return false;
      }
      
      
      /**
       * Builds a building on this planet: removes folliages that are in the
       * basement area of the building and adds this building to objects list.
       * 
       * @param building A building that needs to be built.
       */
      public function build(b:Building) : void
      {
         // Remove the ghost building if there is one
         var ghost:Building = getObject(b.x, b.y) as Building;
         if (ghost && ghost.isGhost && ghost.type == b.type)
         {
            removeObject(ghost);
         }
         
         var removeList:Array = [];
         for each (var object:PlanetObject in getObjectsInArea(b.x, b.xEnd, b.y, b.yEnd))
         {
            if (object.isBlocking)
            {
               throw new Error("Building can't be built on its current location: blocking objects exist!");
            }
            removeList.push(object);
         }
         
         // Special treatment of non-blocking folliage in the bottom-left corner
         // because if I leave it, it will hide level indicator
         var x:int = b.x - 1;
         var y:int = b.y - 1;
         if (x >= 0 && y >= 0)
         {
            object = objectsMatrix[x][y];
            if (object && !object.isBlocking)
            {
               removeList.push(object);
            }
         }
         
         for each (object in removeList)
         {
            removeObject(object);
         }
         addObject(b);
      }
      
      
      public function buildGhost(type:String, x:int, y:int, constructorId: int) : void
      {
         var ghost:Building = new Building();
         ghost.type = type;
         ghost.x = x;
         ghost.y = y;
         ghost.setSize(
            Config.getBuildingWidth(type),
            Config.getBuildingHeight(type)
         );
         ghost.constructorId = constructorId;
         var bonuses: BuildingBonuses = BuildingBonuses.refreshBonuses(getTilesUnderBuilding(ghost));
         ghost.constructionMod = bonuses.constructionTime;
         build(ghost);
      }
      
      
      /**
       * Initializes upgrade process of buildings and units that have not been completed yet.
       */
      public function initUpgradeProcess() : void
      {
         for each (var b:Building in buildings)
         {
            if (!b.upgradePart.upgradeCompleted)
            {
               b.upgradePart.startUpgrade();
            }
         }
         for each (var tUnit: Unit in units)
         {
            if (tUnit.upgradePart.upgradeEndsAt != null)
            {
               tUnit.upgradePart.startUpgrade();
            }
         }
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchOwnerChangeEvent() : void
      {
         dispatchEvent(new PlanetEvent(PlanetEvent.OWNER_CHANGE));
      }
      
      public function dispatchUnitCreateEvent() : void
      {
         dispatchEvent(new PlanetEvent(PlanetEvent.UNIT_UPGRADE_STARTED));
      }
      
      public function dispatchUnitRefreshEvent() : void
      {
         dispatchEvent(new PlanetEvent(PlanetEvent.UNIT_REFRESH_NEEDED));
      }
      
      public function dispatchBuildingUpgradedEvent() : void
      {
         dispatchEvent(new PlanetEvent(PlanetEvent.BUILDING_UPGRADED));
      }
      
      private var _suppressObjectAddEvent:Boolean = false;
      private function dispatchObjectAddEvent(object:PlanetObject) : void
      {
         if (!_suppressObjectAddEvent)
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.OBJECT_ADD, object));
         }
      }
      
      
      private function dispatchObjectRemoveEvent(object:PlanetObject) : void
      {
         dispatchEvent(new PlanetEvent(PlanetEvent.OBJECT_REMOVE, object));
      }
   }
}