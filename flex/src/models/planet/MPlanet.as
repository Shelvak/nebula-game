package models.planet
{
   import components.map.planet.PlanetMap;

   import config.Config;

   import controllers.folliages.PlanetFolliagesAnimator;
   import controllers.objects.ObjectClass;

   import interfaces.ICleanable;
   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.Owner;
   import models.building.Building;
   import models.building.BuildingBonuses;
   import models.factories.BuildingFactory;
   import models.folliage.BlockingFolliage;
   import models.folliage.Folliage;
   import models.folliage.NonblockingFolliage;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.events.MPlanetEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.events.MSSObjectEvent;
   import models.tile.Tile;
   import models.tile.TileKind;
   import models.time.IMTimeEvent;
   import models.time.MTimeEventFixedMoment;
   import models.unit.RaidingUnitEntry;
   import models.unit.Unit;
   import models.unit.UnitKind;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;

   import utils.Objects;
   import utils.StringUtil;
   import utils.datastructures.Collections;


   /**
    * Dispatched when an object has been added to this planet.
    */
   [Event(name="objectAdd", type="models.planet.events.MPlanetEvent")]
   
   /**
    * Dispatched when an object has been removed from this planet.
    */
   [Event(name="objectRemove", type="models.planet.events.MPlanetEvent")]
   
   /**
    * Dispatched when building has been moved to another place. <code>object</code> property
    * is set to the building moved.
    */
   [Event(name="buildingMove", type="models.planet.events.MPlanetEvent")]

   /**
    * Dispatched when an interactive object should be selected by a map
    * component.
    */
   [Event(name="selectObject", type="models.planet.events.MPlanetEvent")]

   [Event(name="unitUpgradeStarted", type="models.planet.events.MPlanetEvent")]
   [Event(name="unitRefreshNeeded", type="models.planet.events.MPlanetEvent")]
   [Event(name="buildingUpgraded", type="models.planet.events.MPlanetEvent")]
   
   [Bindable]
   public class MPlanet extends MMap implements IUpdatable
   {
      private var _zIndexCalculator: ZIndexCalculator = null;
      private var _foliageAnimator: PlanetFolliagesAnimator = null;
      private var _suppressFoliageAnimatorUpdate: Boolean = false;

      private function updateFoliageAnimator(): void {
         if (_suppressFoliageAnimatorUpdate) {
            return;
         }
         _foliageAnimator.setFolliages(nonblockingFolliages);
      }

      public function MPlanet(ssObject: MSSObject) {
         _ssObject = ssObject;
         _ssObject.addEventListener(
            MSSObjectEvent.COOLDOWN_CHANGE, ssObject_cooldownChangeHandler, false, 0, true);
         if (_ssObject.cooldown != null) {
            cooldown = new MPlanetCooldown(_ssObject.cooldown, this);
         }
         super();
         _zIndexCalculator = new ZIndexCalculator(this);
         _foliageAnimator = new PlanetFolliagesAnimator();
         initMatrices();
         _nonblockingFolliages =
            Collections.filter(objects, filterFunction_nonblockingFolliages);
         _blockingFolliages =
            Collections.filter(objects, filterFunction_blockingFolliages);
         _blockingObjects =
            Collections.filter(objects, filterFunction_blockingObjects);
         _buildings = Collections.filter(objects, filterFunction_buildings);
         _folliages = Collections.filter(objects, filterFunction_folliages);
      }

      public static function hasRaiders(raidArg: int,
                                        nextRaidEvent: IMTimeEvent,
                                        battleGround: Boolean,
                                        apocalypseMoment: MTimeEventFixedMoment): Boolean {
         var data: Object;
         var arg: int;
         if (apocalypseMoment != null
                && (nextRaidEvent.after(apocalypseMoment)))
         {
            data = Config.getRaidingApocalypseUnits();
            arg =  1 + Math.round((nextRaidEvent.occursAt.time - apocalypseMoment.occursAt.time)/
                    (1000 * 60 * 60 * 24));
            // for info in raid bar for next raids
            arg += raidArg;
         }
         else if (battleGround)
         {
            data = Config.getRaidingBattlegroundUnits();
            arg = raidArg;
         }
         else
         {
            data = Config.getRaidingPlanetUnits();
            arg = raidArg;
         }
         for (var unitType: String in data)
         {
            var countTo: int = Math.round(StringUtil.evalFormula(
                    data[unitType][1], {'arg': arg}));
            if (countTo > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getRaiders(
         raidArg: int, nextRaidEvent: IMTimeEvent, battleGround: Boolean,
         apocalypseMoment: MTimeEventFixedMoment): ArrayCollection
      {
         var data: Object;
         var arg: int;
         if (apocalypseMoment != null
                 && nextRaidEvent.after(apocalypseMoment))
         {
            data = Config.getRaidingApocalypseUnits();
            arg =  1 + Math.round(
               (nextRaidEvent.occursAt.time - apocalypseMoment.occursAt.time) /
                       (1000 * 60 * 60 * 24)
            );
            // for info in raid bar for next raids
            arg += raidArg;
         }
         else if (battleGround)
         {
            data = Config.getRaidingBattlegroundUnits();
            arg = raidArg;
         }
         else
         {
            data = Config.getRaidingPlanetUnits();
            arg = raidArg;
         }
         var hashedUnits: Object = {};
         for (var unitType: String in data)
         {
            var countFrom: int = Math.round(StringUtil.evalFormula(
                    data[unitType][0], {'arg': arg})
            );
            var countTo: int = Math.round(StringUtil.evalFormula(
                    data[unitType][1], {'arg': arg})
            );
            var prob: Number = StringUtil.evalFormula(
                    data[unitType][2], {'arg': arg}
            );
            if (countTo > 0)
            {
               hashedUnits[unitType] = new RaidingUnitEntry(
                  unitType, countFrom, countTo, prob
               );
            }
         }
         var resultCollection: ArrayCollection = new ArrayCollection();
         for each (var entry: RaidingUnitEntry in hashedUnits)
         {
            resultCollection.addItem(entry);
         }
         resultCollection.sort = new Sort();
         resultCollection.sort.fields = [new SortField('type')];
         resultCollection.refresh();
         return resultCollection;
      }

      public override function get cached(): Boolean {
         return ML.latestPlanet != null
                   && !ML.latestPlanet.fake
                   && ML.latestPlanet.id == id;
      }

      private var f_cleanupStarted:Boolean = false;
      private var f_cleanupComplete:Boolean = false;
      
      
      /**
       * <ul>
       *    <li>calls <code>cleanup()</code> on <code>ssObject</code> and sets it to <code>null</code></li>
       * </ul>
       * 
       * @see MMap#cleanup()
       */
      public override function cleanup(): void {
         f_cleanupStarted = true;
         cooldown = null;
         if (_ssObject != null) {
            _ssObject.cleanup();
            _ssObject.removeEventListener(
               MSSObjectEvent.COOLDOWN_CHANGE, ssObject_cooldownChangeHandler, false);
            _ssObject = null;
         }
         if (_zIndexCalculator != null) {
            _zIndexCalculator = null;
         }
         if (_foliageAnimator != null) {
            _foliageAnimator.cleanup();
            _foliageAnimator = null;
         }
         if (_blockingObjects != null) {
            _blockingObjects.list = null;
            _blockingObjects.filterFunction = null;
            _blockingObjects = null;
         }
         if (_blockingFolliages != null) {
            _blockingFolliages.list = null;
            _blockingFolliages.filterFunction = null;
            _blockingFolliages = null;
         }
         if (_buildings != null) {
            ML.units.disableAutoUpdate();
            units.disableAutoUpdate();
            Collections.cleanListOfICleanables(_buildings);
            units.enableAutoUpdate();
            ML.units.enableAutoUpdate();
            _buildings.list = null;
            _buildings.filterFunction = null;
            _buildings = null;
         }
         if (_folliages != null) {
            _folliages.list = null;
            _folliages.filterFunction = null;
            _folliages = null;
         }
         if (_nonblockingFolliages != null) {
            _nonblockingFolliages.list = null;
            _nonblockingFolliages.filterFunction = null;
            _nonblockingFolliages = null;
         }
         if (_blockingFolliages != null) {
            _blockingFolliages.list = null;
            _blockingFolliages.filterFunction = null;
            _blockingFolliages = null;
         }
         super.cleanup();
         f_cleanupComplete = true;
      }

      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.PLANET</code>.
       * 
       * @see models.map.MMap#mapType
       */
      override public function get mapType(): int {
         return MapType.PLANET;
      }
      
      
      /* ################ */
      /* ### SSOBJECT ### */
      /* ################ */


      private var _ssObject: MSSObject;
      [Bindable(event="willNotChange")]
      /**
       * Reference to a generic <code>SSObject</code> which represents a planet
       * and holds some necessary information for the map.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       */
      public function get ssObject(): MSSObject {
         return _ssObject;
      }

      private function ssObject_cooldownChangeHandler(event: MSSObjectEvent): void {
         if (_ssObject != null) {
            if (_ssObject.cooldown != null) {
               cooldown = new MPlanetCooldown(_ssObject.cooldown, this);
            }
            else {
               cooldown = null;
            }
         }
         else {
            cooldown = null
         }
      }

      private var _cooldown: MPlanetCooldown = null;
      public function set cooldown(value: MPlanetCooldown): void {
         if (_cooldown != value) {
            if (_cooldown != null) {
               _cooldown.cleanup();
            }
            _cooldown = value;
         }
      }
      public function get cooldown(): MPlanetCooldown {
         return _cooldown;
      }

      [Bindable(event="flagDestructionPendingSet")]
      /**
       * Proxy to <code>ssObject.flag_destructionPending</code>.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="flagDestructionPendingSet")]
       * </p>
       * 
       * @see MSSObject#flag_destructionPending
       */
      public override function get flag_destructionPending(): Boolean {
         return _ssObject.flag_destructionPending;
      }

      /**
       * Proxy to <code>ssObject.setFlag_destructionPending()</code>.
       *
       * @see MSSObject#setFlag_destructionPending()
       */
      public override function setFlag_destructionPending(): void {
         _ssObject.setFlag_destructionPending();
      }

      [Bindable(event="modelIdChange")]
      /**
       * Proxy to <code>ssObject.id</code>.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="modelIdChange")]
       * </p>
       * 
       * @see MSSObject#id
       */
      public override function set id(value: int): void {
         if (_ssObject != null && _ssObject.id != value) {
            _ssObject.id = value;
            // this will dispatch all necessary events
            super.id = value;
         }
      }
      public override function get id(): int {
         return _ssObject != null ? _ssObject.id : 0;
      }

      /**
       * @see MSSObject#fake
       */
      public override function set fake(value: Boolean): void {
         if (_ssObject.fake != value) {
            ssObject.fake = value;
            // this will dispatch all necessary events
            super.fake = value;
         }
      }
      public override function get fake(): Boolean {
         return _ssObject.fake;
      }

      /**
       * Proxy to <code>ssObject.width</code>.
       * 
       * @see MSSObject#width
       */
      public function set width(value: int): void {
         _ssObject.width = value;
      }
      public function get width(): int {
         return _ssObject.width;
      }

      /**
       * Proxy to <code>ssObject.height</code>.
       * 
       * @see MSSObject#height
       */
      public function set height(value: int): void {
         _ssObject.height = value;
      }
      public function get height(): int {
         return _ssObject.height;
      }

      /**
       * Proxy to <code>ssObject.solarSystemId</code>.
       * 
       * @see MSSObject#solarSystemId
       */
      public function set solarSystemId(value: int): void {
         _ssObject.solarSystemId = value;
      }
      public function get solarSystemId(): int {
         return _ssObject.solarSystemId;
      }

      /**
       * Proxy to <code>ssObject.inBattleground</code>.
       * 
       * @see MSSObject#inBattleground
       */
      public function get inBattleground(): Boolean {
         return _ssObject.inBattleground;
      }
      
      /**
       * Proxy to <code>ssObject.inMiniBattleground</code>.
       * 
       * @see MSSObject#inMiniBattleground
       */
      public function get inMiniBattleground() : Boolean {
         return _ssObject.inMiniBattleground;
      }


      /* ############################ */
      /* ### AREA LOOPING HELPERS ### */
      /* ############################ */

      public function forEachPointIn(ranges: Array,
                                     boundaryCheck: Boolean,
                                     callback: Function): void {
         Objects.paramNotNull("ranges", ranges);
         Objects.paramNotNull("callback", callback);
         function from(value: int): int {
            return boundaryCheck ? Math.max(value, 0) : value;
         }
         function to(value: int, max:int): int {
            return boundaryCheck ? Math.min(value, max - 1) : value;
         }
         for each (var range: Range2D in ranges) {
            const xFrom: int = from(range.x);
            const xTo: int = to(range.xEnd, width);
            const yFrom: int = from(range.y);
            const yTo: int = to(range.yEnd, height);
            for (var x: int = xFrom; x <= xTo; x++) {
               for (var y: int = yFrom; y <= yTo; y++) {
                  callback.call(null, x, y);
               }
            }
         }
      }

      public function forEachPointUnder(object: MPlanetObject,
                                        includeBuildingGap: Boolean,
                                        boundaryCheck: Boolean,
                                        callback: Function): void {
         Objects.paramNotNull("object", object);
         Objects.paramNotNull("callback", callback);
         const gap: int = includeBuildingGap ? Building.GAP_BETWEEN : 0;
         forEachPointIn(
            [new Range2D(
               object.x - gap, object.xEnd + gap,
               object.y - gap, object.yEnd + gap
            )],
            boundaryCheck, callback
         );
      }
      
      
      /* ################ */
      /* ### LOCATION ### */
      /* ################ */

      public override function get currentLocation() : LocationMinimal {
         return _ssObject.currentLocation;
      }
      
      public function toLocation(): Location {
         return _ssObject.toLocation();
      }
      
      public override function getLocation(x:int, y:int) : Location {
         return toLocation();
      }
      
      protected override function get definedLocationType() : int {
         return LocationType.SS_OBJECT;
      }
      
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean {
         return location.isSSObject && location.id == id;
      }
      
      
      /* ############# */
      /* ### TILES ### */
      /* ############# */
      
      
      /**
       * Two-dimensional array containing tiles of this planet. Regular tiles
       * are represented with null values.
       * 
       * @default <code>null</code>
       */
      protected var tilesMatrix:Array = null;
      
      /**
       * Two-dimensional array containing objects on this planet. One object
       * may occupy more than one tile so all tiles under such object will
       * reference the same instance.
       */
      protected var objectsMatrix:Array = null;

      private function initMatrices(): void {
         tilesMatrix = [];
         objectsMatrix = [];
         for (var i: int = 0; i < width; i++) {
            var objsCol: Array = [];
            var tilesCol: Array = [];
            for (var j: int = 0; j < height; j++) {
               objsCol.push(null);
               tilesCol.push(null);
            }
            objectsMatrix.push(objsCol);
            tilesMatrix.push(tilesCol);
         }
      }
      
      /**
       * Adds a given tile to this planet to appropriate cell in tiles array.
       */
      public function addTile(kind: int, x: int, y: int): void {
         Objects.notEquals(
            kind, [TileKind.REGULAR],
            "Adding regular tiles to the map is not allowed"
         );
         const tile: Tile = new Tile(kind);
         tile.x = x;
         tile.y = y;
         addTileToMatrix(tile);
         if (tile.isResource()) {
            var clone:Tile = tile.cloneFake();
            clone.x++;
            addTileToMatrix(clone);

            clone = tile.cloneFake();
            clone.y++;
            addTileToMatrix(clone);

            clone = tile.cloneFake();
            clone.x++;
            clone.y++;
            addTileToMatrix(clone);
         }
      }

      private function addTileToMatrix(tile:Tile): void {
         tilesMatrix[tile.x][tile.y] = tile;
      }

      /**
       * Removes tile in the given coordinates if one exists. In case it is
       * a resource tile other three related tiles are also removed.
       *
       * @return not fake tile removed or <code>null</code> if such tile has not
       * been removed
       */
      public function removeTile(x: int, y: int): Tile {
         if (!isOnMap(x, y)) {
            return null;
         }
         var tile: Tile = getTile(x, y);
         if (tile == null) {
            return null;
         }
         if (!tile.isResource()) {
            tilesMatrix[x][y] = null;
            return tile;
         }
         var notFake: Tile = null;
         forEachPointIn(
            [new Range2D(x - 1, x + 1, y - 1, y + 1)], true,
            function(x: int, y: int): void {
               const tile:Tile = getTile(x, y);
               if (tile != null && tile.isResource()) {
                  tilesMatrix[x][y] = null;
                  if (!tile.fake) {
                     notFake = tile;
                  }
               }
            }
         );
         return notFake;
      }

      /**
       * Returns <code>Tile</code> object at the given coordinates.
       */
      public function getTile(x: int, y: int): Tile {
         return tilesMatrix[x][y];
      }

      /**
       * Returns kind of a tile at the given coordinates.
       *
       * @param x
       * @param y
       * 
       * @return kind of a tile
       */
      public function getTileKind(x: int, y: int): int {
         var tile:Tile = getTile(x, y);
         return tile != null ? tile.kind : TileKind.REGULAR;
      }
      
      
      /**
       * Determines if given coordinates are defined on this map.
       */
      public function isOnMap(x: int, y: int): Boolean {
         return x >= 0 && x < width && y >= 0 && y < height;
      }
      
      
      private var _resourceTiles:ArrayCollection;
      /**
       * List of all non-fake resource tiles.
       */
      public function get resourceTiles() : ArrayCollection
      {
         if (!_resourceTiles) {
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
       * Recalculates <code>zIndex</code> value of all objects on the planet. This method is called each time
       * new object is added to the planet or a building is moved using <code>moveBuilding()</code> method.
       * However, if you set <code>suppressZIndexCalculation</code> to <code>true</code> the method will
       * return immediately and will not perform any calculations. This should be done when a batch of objects
       * are about to be added because <code>zIndex</code> calculation takes some time to finish. After all
       * objects have been added you must set <code>suppressZIndexCalculation</code> to <code>false</code>
       * and call <code>calculateZIndex()</code> manually.
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
       * @return <code>MPlanetObject</code> that stands on a tile with given coordiantes
       * or <code>null</code> if there is no object there.
       */
      public function getObject(x:int, y:int) : MPlanetObject
      {
         return objectsMatrix[x][y];
      }
      
      
      private var _blockingObjects:ListCollectionView;
      private function filterFunction_blockingObjects(object:MPlanetObject) : Boolean
      {
         return object.isBlocking;
      }
      
      
      private var _buildings:ListCollectionView;
      private function filterFunction_buildings(object:MPlanetObject) : Boolean
      {
         return object is Building;
      }
      /**
       * List of all buildings on the planet (bound to <code>objects</code> list).
       */
      public function get buildings() : ListCollectionView
      {
         return _buildings;
      }

      public function get damagedBuildings() : ListCollectionView
      {
         return Collections.filter(buildings, function(obj: Building): Boolean
         {
            return obj.hp < obj.hpMax && obj.state != Building.REPAIRING
               && obj.upgradePart != null && obj.upgradePart.upgradeEndsAt == null;
         })
      }

      [Bindable (event="planetBuildingUpdated")]
      public function get damagedBuildingsLength(): int
      {
         return damagedBuildings.length;
      }
      
      private var _folliages:ListCollectionView;
      private function filterFunction_folliages(object:MPlanetObject) : Boolean
      {
         return object is Folliage;
      }
      /**
       * Lis of all foliage on the planet (bound to <code>objects</code> list).
       */
      public function get folliages() : ListCollectionView
      {
         return _folliages;
      }
      
      
      private var _blockingFolliages:ListCollectionView;
      private function filterFunction_blockingFolliages(object:MPlanetObject) : Boolean
      {
         return object is BlockingFolliage;
      }
      /**
       * List of all blocking folliages on the planet (bound to <code>objects</code> list).
       */
      public function get blockingFolliages() : ListCollectionView
      {
         return _blockingFolliages;
      }
      
      
      private var _nonblockingFolliages:ListCollectionView;
      private function filterFunction_nonblockingFolliages(object:MPlanetObject) : Boolean
      {
         return object is NonblockingFolliage;
      }
      /**
       * List of all non-blocking folliages on the planet (bound to <code>objects</code> list).
       */
      public function get nonblockingFolliages() : ListCollectionView
      {
         return _nonblockingFolliages;
      }
      
      
      /**
       * Foliage currently being explored or <code>null</code> if exploration is not underway.
       */
      public function get exploredFoliage() : BlockingFolliage {
         if (_ssObject.explorationEndEvent != null &&
            _ssObject.explorationX >= 0 &&
            _ssObject.explorationY >= 0)
            return BlockingFolliage(getObject(_ssObject.explorationX, _ssObject.explorationY));
         return null;
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
         return ML.units.find(id);
      }

      /* units cache */
      private var hasUnitsCache: Object = {};

      private static function getOwnerHex(owners: Array): String
      {
         var ownerHex: String = '';
         for each (var own: int in owners)
         {
            ownerHex += (own + '|');
         }
         return ownerHex;
      }
      
      [Bindable(event="unitRefresh")]
      public function hasActiveUnits(owners: Array, kind: String = null,
                                     hiddenCounts: Boolean = true): Boolean
      {
         var ownerHex: String = getOwnerHex(owners);
         if (hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] == null)
         {
            if (kind == UnitKind.SPACE)
            {
               hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] =
                  hasActiveSpaceUnits(owners, hiddenCounts);
            }
            else if (kind == UnitKind.GROUND)
            {
               hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] =
                  hasActiveGroundUnits(owners, hiddenCounts);
            }
            else
            {
               hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] =
                  (hasActiveGroundUnits(owners, hiddenCounts)
                     || hasActiveSpaceUnits(owners, hiddenCounts));
            }
         }
         return hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts];
      }

      private function hasActiveKindUnitsImpl(owners: Array, kind: String,
                                                 hiddenCounts: Boolean = true): Boolean
      {
         var ownerHex: String = getOwnerHex(owners);
         if (hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] == null)
         {
            hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts] =
               (Collections.findFirst(units,
                  function (unit: Unit): Boolean {
                     if (unit.level > 0 && unit.kind == kind && (!unit.hidden || hiddenCounts)) {
                        for each (var owner: int in owners) {
                           if (owner == Owner.UNDEFINED || owner == unit.owner) {
                              return true;
                           }
                        }
                     }
                     return false;
                  }
               ) != null);
         }
         return hasUnitsCache[ownerHex + '|' + kind + '|' + hiddenCounts];
      }
      
      [Bindable(event="unitRefresh")]
      public function hasActiveGroundUnits(owners: Array,
                                           hiddenCounts: Boolean = true): Boolean
      {
         return hasActiveKindUnitsImpl(owners, UnitKind.GROUND, hiddenCounts);
      }
      
      
      [Bindable(event="unitRefresh")]
      public function hasActiveSpaceUnits(owners: Array,
                                          hiddenCounts: Boolean = true): Boolean
      {
         return hasActiveKindUnitsImpl(owners, UnitKind.SPACE, hiddenCounts);
      }
      
      
      [Bindable(event="unitRefresh")]
      public function hasMovingUnits(owner: int, kind: String): Boolean
      {
         if (hasUnitsCache[owner + '|' + UnitKind.MOVING + '|' + kind] == null)
         {
            hasUnitsCache[owner + '|' + UnitKind.MOVING + '|' + kind] =
               (Collections.findFirst(units,
                  function(unit:Unit) : Boolean
                  {
                     return unit.level > 0 && (unit.owner == owner
                        || (owner == Owner.ENEMY && unit.owner == Owner.NPC))
                     && unit.isMoving &&
                     (unit.kind == kind || kind == null);
                  }
               ) != null);
         }
         return hasUnitsCache[owner + '|' + UnitKind.MOVING + '|' + kind];
      }
      
      public function getActiveHealableUnits(): ListCollectionView
      { 
         return Collections.filter(ML.units, function(unit: Unit): Boolean
         {
            try
            {
               return (unit.level > 0) && definesLocation(unit.location)
               && (unit.owner == Owner.PLAYER || unit.owner == Owner.ALLY 
                  || unit.owner == Owner.NAP);
            }
            catch (err:Error)
            {
               // NPE is thrown when cleanup() method has been called on the instance of a MPlanet and global
               // units list is modified. definesLocation() no longer works but the filter function is
               // called anyway.
            }
            return false;
         });
      }

      /* for count of active units */
      private var activeUnitsCountCache: Object = {};
      
      [Bindable (event="unitRefresh")]
      public function getActiveUnitsCount(owner: int, kind: String): int
      {
         if (activeUnitsCountCache[owner + '|' + kind] == null)
         {
            activeUnitsCountCache[owner + '|' + kind] = getActiveUnits(owner, kind).length;
         }
         return activeUnitsCountCache[owner + '|' + kind];
      }
      
      public function getActiveUnits(owner: int, kind: String = null): ListCollectionView
      {
         // For some reason if i filter this planet units i dont get all CollectionChange events in filtered
         // collection, but if i filter ML.units and add definesLocation check inside, everything works fine.
         return Collections.filter(ML.units, function(unit: Unit): Boolean
         {
            try
            {
               return (unit.level > 0) && definesLocation(unit.location)
               && (owner == Owner.ENEMY?(unit.owner == owner || unit.owner == Owner.NPC):unit.owner == owner) 
               && (unit.kind == kind || kind == null)
               && (kind != null || !unit.isMoving);
            }
            catch (err:Error)
            {
               // NPE is thrown when cleanup() method has been called on the instance of a MPlanet and global
               // units list is modified. definesLocation() no longer works but the filter function is
               // called anyway.
            }
            return false;
         });
      }

      /* aggressive ground units cache */
      private var aggressiveGroundUnitsCache: Object = {};
      
      [Bindable(event="unitRefresh")]
      public function hasAggressiveGroundUnits(owner: int = Owner.PLAYER): Boolean
      {
         if (aggressiveGroundUnitsCache[owner] == null)
         {
            aggressiveGroundUnitsCache[owner] =
               (getAggressiveGroundUnits(owner).length > 0);
         }
         return aggressiveGroundUnitsCache[owner];
      }
      
      public function getAggressiveGroundUnits(owner: int = Owner.PLAYER): ListCollectionView
      {
         return Collections.filter(ML.units, function(unit: Unit): Boolean
         {
            try
            {
               return (unit.level > 0
                  && definesLocation(unit.location) 
                  && unit.kind == UnitKind.GROUND
                  && (!unit.hidden)
                  && (unit.owner == owner || (owner == Owner.ENEMY && unit.owner == Owner.NPC))
                  && unit.hasGuns);
            }
            catch (err:Error)
            {
               // NPE is thrown when cleanup() method has been called on the instance of a MPlanet and global
               // units list is modified. definesLocation() no longer works but the filter function is
               // called anyway.
            }
            return false;
         });
      }
      
      
      [Bindable (event = "planetBuildingUpgraded")]
      public function getUnitsFacilities(): ListCollectionView
      {
         var constructors:Array = Config.getConstructors(ObjectClass.UNIT);
         var facilities:ListCollectionView = Collections.filter(buildings, 
            function(building: Building): Boolean
            {
               var result:Boolean = constructors.indexOf(building.type) != -1 &&
               building.state != Building.INACTIVE;
               return result;
            }
         );
         
         facilities.sort = new Sort();
         facilities.sort.fields = [new SortField('constructablePosition', false, false, true), 
            new SortField('totalConstructorMod', false, true, true), 
            new SortField('id', false, false, true)];
         facilities.refresh();
         return facilities;
      }
      
      
      /**
       * Adds <code>MPlanetObject</code> to the planet and dispatches
       * <code>MPlanetEvent.OBJECT_ADD</code> event.
       * 
       * @param obj An object that needs to be added
       * 
       * @throws Error if another object occupies the same space as the given one
       */
      public override function addObject(obj:BaseModel) : void
      {
         var object:MPlanetObject = MPlanetObject(obj);
         // Check if there are no objects in the same place
         var mapObjects:ArrayCollection = getObjectsInArea(object.x, object.xEnd, object.y, object.yEnd);
         if (mapObjects.length != 0)
         {
            throw new Error(
               "Can't add object " + obj + " to the planet (id: " + id + "): another object(s) " +
               mapObjects + " occupies the same space"
            );
         }
         
         fillObjectsMatrix(object);
         objects.addItem(object);
         calculateZIndex();
         updateFoliageAnimator();
         dispatchObjectAddEvent(object);
      }
      
      
      /**
       * Sets slots of <code>objectsMatrix</code> to given object where <code>x</code> varies in range
       * <code>[object.x; object.xEnd]</code> and <code>y</code> - <code>[object.y; object.yEnd]</code>.
       */
      private function fillObjectsMatrix(object:MPlanetObject) : void
      {
         for (var x:int = object.x; x <= object.xEnd; x++)
         {
            for (var y:int = object.y; y <= object.yEnd; y++)
            {
               objectsMatrix[x][y] = object;
            }
         }
      }
      
      
      /**
       * Adds all objects to this planet. <code>MPlanetEvent.OBJECT_ADD</code> event is suppressed during
       * this operation.
       * 
       * @param list list of <code>MPlanetObject<code>s to add to this planet.
       * 
       * @see #addObject()
       */
      public override function addAllObjects(list:IList) : void
      {
         _suppressObjectAddEvent = true;
         _suppressZIndexCalculation = true;
         _suppressFoliageAnimatorUpdate = true;
         super.addAllObjects(list);
         _suppressObjectAddEvent = false;
         _suppressZIndexCalculation = false;
         _suppressFoliageAnimatorUpdate = false;
         calculateZIndex();
         updateFoliageAnimator();
      }
      
      
      /**
       * Removes <code>MPlanetObject</code> from the planet and dispatches
       * <code>MPlanetEvent.OBJECT_REMOVE</code> event if the object has actually been removed.
       * 
       * @param obj An object that needs to be removed
       * @param silent not used
       */
      public override function removeObject(obj:BaseModel, silent:Boolean = false) : * {
         var object: MPlanetObject = Objects.paramNotNull("obj", obj);
         var x: int = object.x;
         var y: int = object.y;
         if (objectsMatrix[x][y] == object) {
            clearObjectsMatrix(x, object.xEnd, y, object.yEnd);
            objects.removeItemAt(objects.getItemIndex(object));
            dispatchObjectRemoveEvent(object);
            if (object is ICleanable) {
               ICleanable(object).cleanup();
            }
            return object;
         }
         return null;
      }
      
      [Bindable (event="planetBuildingUpgraded")]
      public function get hasBuildingsWithGuns(): Boolean
      {
         for each (var building: Building in buildings)
         {
            if (building.hasGuns && !building.isGhost &&
                    building.state == Building.ACTIVE)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * Sets slots of <code>objectsMatrix</code> to <code>null</code> where <code>x</code> varies in a range
       * <code>[xMin; xMax]</code> and <code>y</code> - <code>[yMin; yMax]</code>.
       */
      private function clearObjectsMatrix(xMin:int, xMax:int, yMin:int, yMax:int) : void {
         for (var x:int = xMin; x <= xMax; x++) {
            for (var y:int = yMin; y <= yMax; y++) {
               objectsMatrix[x][y] = null;
            }
         }
      }
      
      
      /**
       * Looks for and returns a building with a given id.
       */
      public function getBuildingById(id:int) : Building {
         return Collections.findFirstWithId(buildings, id);
      }
      
      /**
       * Looks for and returns blocking foliage with a given id.
       */
      public function getBlockingFoliageById(id:int) : BlockingFolliage {
         return Collections.findFirstWithId(blockingFolliages, id);
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
      public function getBuildingByConstructable(id:int, type:String) : Building {
         return Collections.findFirst(buildings,
            function(building:Building) : Boolean {
               return building.isConstructor(type) &&
               building.constructableType != null &&
               building.constructableId == id;
            }
         );
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
      public function buildingsInAreaExist(xMin:int, xMax:int, yMin:int, yMax:int,
                                           skip:Building = null) : Boolean
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
       * @param building Building to be examined.
       * 
       * @return <code>true</code> if there are at least one building in the
       * area of the given building or <code>false</code> otherwise.
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
       * Determines if any blocking foliage in given building basement's area exist.
       * 
       * @param building Building to be examined.
       * 
       * @return <code>true</code> if there are at least one blocking folliage in the basement
       * area of the given building or <code>false</code> otherwise.
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
       * Determines if the given object would be on the map with it's whole ground.
       * This method lets examine objects that are not part of this map yet.
       */
      public function isObjectOnMap(object:MPlanetObject) : Boolean {
         return isOnMap(object.x, object.y)
                   && isOnMap(object.xEnd, object.yEnd);
      } 
      
      
      /**
       * Determines if a given building might occupy restricted tiles.
       *  
       * @param building
       * 
       * @return <code>true</code> if the given building might occupy tiles that
       * it could not be built on or <code>false</code> otherwise.
       */
      public function restrTilesUnderBuildingExist(building: Building): Boolean {
         for (var x: int = building.x; x <= building.xEnd; x++) {
            for (var y: int = building.y; y <= building.yEnd; y++) {
               if (building.isTileRestricted(getTileKind(x, y))) {
                  return true;
               }
            }
         }
         return false;
      }

      /**
       * Determines if are any restricted tiles around the building.
       */
      public function restrTilesAroundBuildingExist(building: Building): Boolean {
         Objects.paramNotNull("building", building);
         var border:int = PlanetMap.BORDER_SIZE;
         var bx:int = building.x;
         var by:int = building.y;
         var bxEnd:int = building.xEnd;
         var byEnd:int = building.yEnd;
         for (var x: int = bx - border; x <= bxEnd + border; x++) {
            for (var y: int = by - border; y <= byEnd + border; y++) {
               if (isOnMap(x, y)
                      && (x < bx || x > bxEnd || y < by || y > byEnd)
                      && building.isTileRestricted(getTileKind(x, y), true)) {
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
      public function getTilesUnderBuilding(building:Building) : Array {
         var result: Array = [];
         for (var x: int = Math.max(0, building.x);
              x < Math.min(width, building.xEnd + 1); x++) {
            for (var y: int = Math.max(0, building.y);
                 y < Math.min(height, building.yEnd + 1); y++) {
               result.push(getTileKind(x, y));
            }
         }
         return result;
      }
      
      
      /**
       * Use this method to find out if a building can be built in its current position.
       *  
       * @param building A building that is about to be built
       * @return <code>true</code> if a building can be built or <code>false</code>
       * otherwise.
       */
      public function canBeBuilt(building: Building): Boolean {
         return isObjectOnMap(building)
                   && !restrTilesUnderBuildingExist(building)
                   && !restrTilesAroundBuildingExist(building)
                   && !buildingsAroundExist(building)
                   && !blockingFolliagesUnderExist(building);
      }


      /**
       * Builds a building on this planet: removes foliage that are in the
       * basement area of the building and adds this building to objects list.
       * 
       * @param b A building that needs to be built.
       */
      public function build(b:Building) : void
      {
         // Remove the ghost building if there is one
         var ghost:MPlanetObject = getObject(b.x, b.y);
         if (ghost && ghost is Building && Building(ghost).isGhost && Building(ghost).type == b.type)
         {
            removeObject(ghost);
         }
         
         checkBlockingObjectsUnder(b);
         removeNonBlockingFoliageUnder(b);
         addObject(b);
      }
      
      
      /**
       * Builds a ghost - building which is in the build queue of a costructor.
       * 
       * @param type type of a building
       * @param x logical x coordinate
       * @param y logical y coordinate 
       * @param constructorId if of a constructor this ghost will be constructed by
       */
      public function buildGhost(type:String, x:int, y:int, constructorId: int,
              prepaid: Boolean) : void
      {
         
         var ghost:Building = BuildingFactory.createGhost(type, x, y, constructorId,
            prepaid);
         var bonuses: BuildingBonuses = BuildingBonuses.refreshBonuses(getTilesUnderBuilding(ghost));
         ghost.constructionMod = bonuses.constructionTime;
         build(ghost);
      }
      
      
      /**
       * Moves the building to a new location:
       * <ul>
       *    <li>moves building by calling <code>building.moveTo()</code> to <code>newX</code> and<code>newY</code></li>
       *    <li>checks if there are no blocking objects under the building<li/>
       *    <li>removes all non blocking folliages under the building</li>
       * Components are not notified.
       * 
       * @param b a building to move. Must still be at its old location.
       * @param newX new x coordinate
       * @param newY new y coordinate
       */
      public function moveBuilding(b: Building, newX: int, newY: int): void {
         if (b.x == newX && b.y == newY) {
            return;
         }
         clearObjectsMatrix(b.x, b.xEnd, b.y, b.yEnd);
         b.moveTo(newX, newY);
         checkBlockingObjectsUnder(b);
         removeNonBlockingFoliageUnder(b);
         fillObjectsMatrix(b);
         calculateZIndex();
         if (hasEventListener(MPlanetEvent.BUILDING_MOVE)) {
            dispatchEvent(new MPlanetEvent(MPlanetEvent.BUILDING_MOVE, b));
         }
      }
      
      
      private function removeNonBlockingFoliageUnder(b:Building) : void
      {
         var removeList:Array = [];
         for each (var object:MPlanetObject in getObjectsInArea(b.x, b.xEnd, b.y, b.yEnd))
         {
            if (!object.isBlocking)
            {
               removeList.push(object);
            }
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
      }
      
      
      /**
       * Checks if there are no objects under the given building. If there is at least one, throws error.
       */
      private function checkBlockingObjectsUnder(b:Building) : void
      {
         var blockingObjects:Array = [];
         for each (var object:MPlanetObject in getObjectsInArea(b.x, b.xEnd, b.y, b.yEnd))
         {
            if (object.isBlocking && object !== b)
            {
               blockingObjects.push(object);
            }
         }
         if (blockingObjects.length > 0)
         {
            throw new Error("Building " + b + " can't be built on its current location. " +
               "Blocking objects exist:\n" + blockingObjects.join("\n"));
         }
      }
      
      
      /**
       * Initializes upgrade process of buildings and units that have not been completed yet.
       */
      public function initUpgradeProcess(): void {
         for each (var b: Building in buildings) {
            if (!b.upgradePart.upgradeCompleted) {
               b.upgradePart.startUpgrade();
            }
         }
         for each (var tUnit: Unit in units) {
            if (tUnit.upgradePart.upgradeEndsAt != null) {
               tUnit.upgradePart.startUpgrade();
            }
         }
      }


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public override function update(): void {
         updateItem(ssObject);
         super.update();
      }

      public override function resetChangeFlags(): void {
         resetChangeFlagsOf(ssObject);
         super.resetChangeFlags();
      }


      /* ################### */
      /* ### UI COMMANDS ### */
      /* ################### */

      public function selectObject(object: MPlanetObject): void {
         Objects.paramNotNull("object", object);
         if (hasEventListener(MPlanetEvent.UICMD_SELECT_OBJECT)) {
            dispatchEvent(new MPlanetEvent(MPlanetEvent.UICMD_SELECT_OBJECT, object));
         }
      }

      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */

      public function invalidateUnitCachesAndDispatchEvent(): void {
         hasUnitsCache = {};
         activeUnitsCountCache = {};
         aggressiveGroundUnitsCache = {};
         if (!f_cleanupStarted && !f_cleanupComplete) {
            dispatchThisEvent(MPlanetEvent.UNIT_REFRESH_NEEDED);
         }
      }

      public function dispatchBuildingUpgradedEvent(): void {
         dispatchThisEvent(MPlanetEvent.BUILDING_UPGRADED);
      }

      public function dispatchBuildingUpdatedEvent(): void {
         dispatchThisEvent(MPlanetEvent.BUILDING_UPDATED);
      }

      private var _suppressObjectAddEvent: Boolean = false;
      private function dispatchObjectAddEvent(object: MPlanetObject): void {
         if (!_suppressObjectAddEvent && hasEventListener(MPlanetEvent.OBJECT_ADD)) {
            dispatchEvent(new MPlanetEvent(MPlanetEvent.OBJECT_ADD, object));
         }
      }

      private function dispatchObjectRemoveEvent(object: MPlanetObject): void {
         if (hasEventListener(MPlanetEvent.OBJECT_REMOVE)) {
            dispatchEvent(new MPlanetEvent(MPlanetEvent.OBJECT_REMOVE, object));
         }
      }

      private function dispatchThisEvent(event: String): void {
         dispatchSimpleEvent(MPlanetEvent, event);
      }
   }
}