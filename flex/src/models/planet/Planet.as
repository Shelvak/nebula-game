package models.planet
{
   import config.Config;
   
   import controllers.folliages.PlanetFolliagesAnimator;
   import controllers.objects.ObjectClass;
   
   import flash.events.Event;
   
   import interfaces.ICleanable;
   
   import models.BaseModel;
   import models.Owner;
   import models.building.Building;
   import models.building.BuildingBonuses;
   import models.building.Npc;
   import models.folliage.BlockingFolliage;
   import models.folliage.Folliage;
   import models.folliage.NonblockingFolliage;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.events.PlanetEvent;
   import models.solarsystem.MSSObject;
   import models.tile.Tile;
   import models.tile.TileKind;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   
   import utils.datastructures.Collections;
   
   
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
   public class Planet extends MMap
   {
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
      
      
      public function Planet(ssObject:MSSObject)
      {
         _ssObject = ssObject;
         super();
         units.addEventListener(CollectionEvent.COLLECTION_CHANGE, dispatchUnitRefreshEvent,
                                false, 0, true);
         _zIndexCalculator = new ZIndexCalculator(this);
         _folliagesAnimator = new PlanetFolliagesAnimator();
         initMatrices();
      }
      
      
      /**
       * <ul>
       *    <li>calls <code>cleanup()</code> on <code>ssObject</code> and sets it to <code>null</code></li>
       * </ul>
       * 
       * @see Map#cleanup()
       */
      public override function cleanup() : void
      {
         super.cleanup();
         if (_ssObject)
         {
            _ssObject.cleanup();
            _ssObject = null;
         }
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
      
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.PLANET</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int
      {
         return MapType.PLANET;
      }
      
      
      /* ################ */
      /* ### SSOBJECT ### */
      /* ################ */
      
      
      private var _ssObject:MSSObject;
      [Bindable(event="willNotChange")]
      /**
       * Reference to a generic <code>SSObject</code> wich represents a planet and holds some
       * necessary information for the map.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get ssObject() : MSSObject
      {
         return _ssObject;
      }
      
      
      [Bindable(event="flagDestructionPendingSet")]
      /**
       * Proxy to <code>ssObject.flag_destructionPending</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="flagDestructionPendingSet")]</i></p>
       */
      public override function get flag_destructionPending() : Boolean
      {
         return _ssObject.flag_destructionPending;
      }
      
      
      /**
       * Proxy to <code>ssObject.setFlag_destructionPending()</code>.
       */
      public override function setFlag_destructionPending():void
      {
         _ssObject.setFlag_destructionPending();
      }
      
      
      [Bindable(event="modelIdChange")]
      /**
       * Proxy to <code>ssObject.id</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public override function set id(value:int) : void
      {
         if (_ssObject.id != value)
         {
            _ssObject.id = value;
            // this will dispatch all necessary events
            super.id = value;
         }
      }
      /**
       * @private
       */
      public override function get id() : int
      {
         return _ssObject.id;
      }
      
      
      /**
       * Proxy to <code>ssObject.fake</code>.
       */
      public override function set fake(value:Boolean) : void
      {
         if (_ssObject.fake != value)
         {
            ssObject.fake = value;
            // this will dispatch all necessary events
            super.fake = value;
         }
      }
      /**
       * @private
       */
      public override function get fake() : Boolean
      {
         return _ssObject.fake;
      }
      
      
      /**
       * Proxy to <code>ssObject.width</code>.
       */
      public function set width(value:int) : void
      {
         _ssObject.width = value;
      }
      /**
       * @private
       */
      public function get width() : int
      {
         return _ssObject.width;
      }
      
      
      /**
       * Proxy to <code>ssObject.height</code>.
       */
      public function set height(value:int) : void
      {
         _ssObject.height = value;
      }
      /**
       * @private
       */
      public function get height() : int
      {
         return _ssObject.height;
      }
      
      
      /**
       * Proxy to <code>ssObject.angle</code>.
       */
      public function set angle(value:Number) : void
      {
         _ssObject.angle = value;
      }
      /**
       * @private
       */
      public function get angle() : Number
      {
         return _ssObject.angle;
      }
      
      
      /**
       * Proxy to <code>ssObject.angleRadians</code>.
       */
      public function get angleRadians() : Number
      {
         return _ssObject.angleRadians;
      }
      
      
      /**
       * Proxy to <code>ssObject.angle</code>.
       */
      public function set position(value:int) : void
      {
         _ssObject.position = value;
      }
      /**
       * @private
       */
      public function get position() : int
      {
         return _ssObject.position;
      }
      
      
      /**
       * Proxy to <code>ssObject.solarSystemId</code>.
       */
      public function set solarSystemId(value:int) : void
      {
         _ssObject.solarSystemId = value;
      }
      /**
       * @private
       */
      public function get solarSystemId() : int
      {
         return _ssObject.solarSystemId;
      }
      
      
      /* ################ */
      /* ### LOCATION ### */
      /* ################ */
      
      
      public override function get currentLocation() : LocationMinimal
      {
         var locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(new LocationMinimal());
         locWrapper.type = LocationType.SOLAR_SYSTEM;
         locWrapper.id = solarSystemId;
         locWrapper.angle = angle;
         locWrapper.position = position;
         return locWrapper.location;
      }
      
      
      public function toLocation(): Location
      {
         return _ssObject.toLocation();
      }
      
      
      public override function getLocation(x:int, y:int) : Location
      {
         return toLocation();
      }
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.SS_OBJECT;
      }
      
      
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean
      {
         return location.isSSObject && location.id == id;
      }
      
      
      /* ############# */
      /* ### TILES ### */
      /* ############# */
      
      
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
      
      
      private function initMatrices() :void
      {
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
         if (_suppressZIndexCalculation || objects.length == 0)
         {
            return;
         }
         _zIndexCalculator.calculateZIndex();
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
         return objectsMatrix[x][y];
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
         return Collections.applyFilter(new ArrayCollection(objects.source), filterFunction);
      }
      
      
      /**
       * List of all blocking objects on this planet.
       */
      public function get blockingObjects() : ArrayCollection
      {
         return filterObjects(
            function(item:Object) : Boolean
            {
               return PlanetObject(item).isBlocking;
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
         return Collections.findFirst(units, function(unit:Unit) : Boolean { return unit.id == id });
      }
      
      
      [Bindable(event="unitRefresh")]
      public function get hasActiveUnits(): Boolean
      {
         return hasActiveGroundUnits || hasActiveSpaceUnits;
      }
      
      [Bindable(event="unitRefresh")]
      public function get hasActiveGroundUnits(): Boolean
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return unit.level > 0 && unit.kind == UnitKind.GROUND;
         }).length > 0;
      }
      
      [Bindable(event="unitRefresh")]
      public function get hasActiveSpaceUnits(): Boolean
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return unit.level > 0 && unit.kind == UnitKind.SPACE;
         }).length > 0;
      }
      
      [Bindable(event="unitRefresh")]
      public function hasMovingUnits(owner: int, kind: String): Boolean
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return unit.level > 0 && unit.owner == owner && unit.squadronId != 0
            && (unit.kind == kind || kind == null);
         }).length > 0;
      }
      
      [Bindable(event="unitRefresh")]
      public function getActiveUnits(owner: int, kind: String = null): ListCollectionView
      {
         // For some reason if i filter this planet units i dont get all CollectionChange events in filtered
         // collection, but if i filter ML.units and add definesLocation check inside, everything works fine.
         return Collections.filter(ML.units, function(unit: Unit): Boolean
         {
            try
            {
               return (unit.level > 0) && definesLocation(unit.location)
               && (owner == Owner.ENEMY?(unit.owner == owner || unit.owner == Owner.UNDEFINED):unit.owner == owner) 
               && (unit.kind == kind || kind == null)
               && (kind != null || !unit.isMoving);
            }
            catch (err:Error)
            {
               // NPE is thrown when cleanup() method has been called on the instance of a Planet and global
               // units list is modified. definesLocation() no longer works but the filter function is
               // called anyway.
            }
            return false;
         });
      }
      
      
      [Bindable(event="unitRefresh")]
      public function getActiveGroundUnits(owner: int): ListCollectionView
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return ((unit.level > 0) && (unit.kind == UnitKind.GROUND) && (unit.owner == owner));
         });
      }
      
      
      [Bindable(event="unitRefresh")]
      public function getActiveSpaceUnits(owner: int): ListCollectionView
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return ((unit.level > 0) && (unit.kind == UnitKind.GROUND) && (unit.owner == owner));
         });
      }
      
      [Bindable(event="unitRefresh")]
      public function getActiveStorableGroundUnits(owner: int): ListCollectionView
      {
         return Collections.filter(units, function(unit: Unit): Boolean
         {
            return ((unit.level > 0) && (unit.kind == UnitKind.GROUND) && (unit.volume > 0) && (unit.owner == owner));
         });
      }
      
      
      [Bindable (event = "planetBuildingUpgraded")]
      public function getUnitsFacilities(): ListCollectionView
      {
         var constructors: Array = Config.getConstructors(ObjectClass.UNIT);
         var facilities : ListCollectionView = Collections.filter(buildings, 
            function(building: Building): Boolean
            {
               return (constructors.indexOf(building.type) != -1) 
                  && (building.state != Building.INACTIVE);
            });
         
         facilities.sort = new Sort();
         facilities.sort.fields = [new SortField('constructablePosition', false, false, true), 
                                   new SortField('constructorMod', false, true, true)];
         facilities.refresh();
         return facilities;
      }
      
      /**
       * 
       * returns npc building in which this unit belongs
       * 
       */      
      public function findUnitBuilding(unit: Unit): Npc
      {
         for each (var building: Building in buildings)
         {
            if (building is Npc)
            {
               if ((building as Npc).units.find(unit.id) != null)
               {
                  return building as Npc;
               }
            }
         }
         return null;
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
      public override function addObject(obj:BaseModel) : void
      {
         var object:PlanetObject = PlanetObject(obj);
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
         objects.addItem(object);
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
       * @param silent is not used
       * 
       * @throws Error if <code>object</code> is <code>null</code>
       */
      public override function removeObject(obj:BaseModel, silent:Boolean = false) : *
      {
         if (obj == null)
         {
            throw new Error("object must be valid instance of PlanetObject");
         }
         var object:PlanetObject = PlanetObject(obj);
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
            objects.removeItemAt(objects.getItemIndex(object));
            dispatchObjectRemoveEvent(object);
            if (object is ICleanable)
            {
               ICleanable(object).cleanup();
            }
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
         var list:IList = Collections.filter(buildings,
            function(building:Building) : Boolean
            {
               return building.id == id;
            }
         );
         return list.length > 0 ? Building(list.getItemAt(0)) : null;
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
      public function getBuildingByConstructable(id:int, type:String) : Building
      {
         var list:IList = Collections.filter(buildings,
            function(building:Building) : Boolean
            {
               return building.isConstructor(type) &&
                      building.constructableType != null &&
                      building.constructableId == id;
            }
         );
         return list.length > 0 ? Building(list.getItemAt(0)) : null;
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
       * Returns an array of tiles under the given building no mater if it can on can't be build there.
       *  
       * @param building A building (might not be part of this map).
       * 
       * @return Array ot tiles under the building. Elements in the array are integers
       * from <code>TileKind</code> class.
       */      
      public function getTilesUnderBuilding(building:Building) : Array
      {
         var result:Array = [];
         for (var x:int = Math.max(0, building.x); x < Math.min(width, building.xEnd + 1); x++)
         {
            for (var y:int = Math.max(0, building.y); y < Math.min(height, building.yEnd + 1); y++)
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
         var ghost:PlanetObject = getObject(b.x, b.y);
         if (ghost && ghost is Building && Building(ghost).isGhost && Building(ghost).type == b.type)
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
      
      
      public function dispatchUnitCreateEvent() : void
      {
         if (hasEventListener(PlanetEvent.UNIT_UPGRADE_STARTED))
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.UNIT_UPGRADE_STARTED));
         }
      }
      
      
      private function dispatchUnitRefreshEvent(e: Event) : void
      {
         if (hasEventListener(PlanetEvent.UNIT_REFRESH_NEEDED))
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.UNIT_REFRESH_NEEDED));
         }
      }
      
      
      public function dispatchBuildingUpgradedEvent() : void
      {
         if (hasEventListener(PlanetEvent.BUILDING_UPGRADED))
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.BUILDING_UPGRADED));
         }
      }
      
      
      private var _suppressObjectAddEvent:Boolean = false;
      private function dispatchObjectAddEvent(object:PlanetObject) : void
      {
         if (!_suppressObjectAddEvent && hasEventListener(PlanetEvent.OBJECT_ADD))
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.OBJECT_ADD, object));
         }
      }
      
      
      private function dispatchObjectRemoveEvent(object:PlanetObject) : void
      {
         if (hasEventListener(PlanetEvent.OBJECT_REMOVE))
         {
            dispatchEvent(new PlanetEvent(PlanetEvent.OBJECT_REMOVE, object));
         }
      }
   }
}