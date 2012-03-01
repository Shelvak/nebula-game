package models.galaxy
{
   import flash.geom.Point;

   import interfaces.IUpdatable;

   import models.galaxy.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.map.MapArea;
   import models.map.MapType;
   import models.map.events.MMapEvent;
   import models.solarsystem.MSolarSystem;
   import models.time.MTimeEventFixedMoment;
   import models.time.events.MTimeEventEvent;

   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;

   import utils.Objects;
   import utils.datastructures.Collections;


   /**
    * Dispatched when new location becomes visible inside the bounds of
    * currently visible galaxy area.
    */
   [Event(name="newVisibleLocation", type="models.galaxy.events.GalaxyEvent")]
   
   /**
    * Dispatched when <code>hasWormholes</code> property have changed.
    */
   [Event(name="hasWormholesChange", type="models.galaxy.events.GalaxyEvent")]

   /**
    * @see models.galaxy.events.GalaxyEvent#APOCALYPSE_START_EVENT_CHANGE
    */
   [Event(name="apocalypseStartEventChange", type="models.galaxy.events.GalaxyEvent")]

   /**
    * Dispatched when a solar system has been added to or removed from the list
    * of solar systems with player.
    */
   [Event(name="objectsUpdate", type="models.map.events.MMapEvent")]
   
   public class Galaxy extends MMapSpace implements IUpdatable
   {
      private var _fowMatrixBuilder:FOWMatrixBuilder;
      
      public function Galaxy() {
         super();
         _wormholes = Collections.filter(naturalObjects, ff_wormholes);
         _wormholes.addEventListener(CollectionEvent.COLLECTION_CHANGE, wormholes_collectionChangeHandler);
         _solarSystems = Collections.filter(naturalObjects, ff_solarSystems);
         _solarSystemsWithPlayer = Collections.filter(naturalObjects, ff_solarSystemsWithPlayer);
         _solarSystemsWithPlayer.addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            solarSystemsWithPlayer_collectionChangeHandler, false, 0, true
         );
      }
      
      public override function get cached() : Boolean {
         return ML.latestGalaxy != null && !ML.latestGalaxy.fake && id == ML.latestGalaxy.id;
      }

      private var _apocalypseStartEvent: MTimeEventFixedMoment = null;
      [Bindable(event="apocalypseStartEventChange")]
      public function set apocalypseStartEvent(value: MTimeEventFixedMoment): void {
         if (_apocalypseStartEvent != value) {
            _apocalypseStartEvent = value;
            dispatchSimpleEvent(
               GalaxyEvent, GalaxyEvent.APOCALYPSE_START_EVENT_CHANGE
            );
            _apocalypseStartEvent.addEventListener(
                    MTimeEventEvent.HAS_OCCURED_CHANGE,
                    dispatchApocalypseStartEventChangeEvent)
         }
      }
      public function get apocalypseStartEvent(): MTimeEventFixedMoment {
         return _apocalypseStartEvent;
      }

      [Bindable(event="apocalypseStartEventChange")]
      public function get apocalypseActive(): Boolean {
         return _apocalypseStartEvent != null;
      }

      [Bindable(event="apocalypseStartEventChange")]
      public function get apocalypseHasStarted(): Boolean {
         return _apocalypseStartEvent != null
                 && _apocalypseStartEvent.hasOccured;
      }

      [Required]
      [Bindable(event="willNotChange")]
      /**
       * ID of a battleground solar system in this galaxy.
       * 
       * <p><i><b>Metadata:</b></br>
       * [Required]</br>
       * [Bindable(event="willNotChange")]
       * </i></p>
       * 
       * @default 0
       */
      public var battlegroundId:int = 0;
      
      private var _solarSystems:ListCollectionView;
      private function ff_solarSystems(ss:MSolarSystem) : Boolean {
         return !ss.isWormhole;
      }
      [Bindable(event="willNotChange")]
      /**
       * A list of all visible solar systems (not wormholes) in this galaxy (bound to
       * <code>naturalObjects</code> list). <p><b>Never null</b>.</p>
       * 
       * <p><i><b>Metadata:</b></br>
       * [Bindable(event="willNotChange")]
       * </i></p>
       */
      public function get solarSystems() : ListCollectionView {
         return _solarSystems;
      }
      
      private var _solarSystemsWithPlayer:ListCollectionView;
      private function ff_solarSystemsWithPlayer(ss:MSolarSystem) : Boolean {
         return ss.metadata != null &&
                ss.metadata.playerAssets;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of solar systems player has any military assets in. <p><b>Never null.</b></p>
       */
      public function get solarSystemsWithPlayer() : ListCollectionView {
         return _solarSystemsWithPlayer;
      }
      /**
       * Refreshes <code>solarSystemsWithPlayer</code> collection.
       */
      public function refreshSolarSystemsWithPlayer() : void {
         _solarSystemsWithPlayer.refresh();
      }

      private function solarSystemsWithPlayer_collectionChangeHandler(event: CollectionEvent) : void {
         if (event.kind == CollectionEventKind.REFRESH) {
            dispatchSimpleEvent(MMapEvent, MMapEvent.OBJECTS_UPDATE);
         }
      }
      
      private var _wormholes:ListCollectionView;
      private function ff_wormholes(ss:MSolarSystem) : Boolean {
         return ss.isWormhole;
      }
      [Bindable(event="willNotChange")]
      /**
       * A list of all visible wormholes in this galaxy (bound to <code>naturalObjects</code> list).
       * <p><b>Never null</b>.</p>
       * 
       * <p><i><b>Metadata:</b></br>
       * [Bindable(event="willNotChange")]
       * </i></p>
       */
      public function get wormholes() : ListCollectionView {
         return _wormholes;
      }
      
      /**
       * Determines if a solar system with given id, if exists, is a wormhole. If there is not such solar
       * system returns <code>false</code>.
       */
      public function isWormhole(ssId:int) : Boolean {
         var ss:MSolarSystem = Collections.findFirstWithId(_wormholes, ssId);
         return ss != null && ss.isWormhole;
      }
      
      /**
       * Determines if the given solar system id is that of a battleground solar system.
       */
      public function isBattleground(ssId:int) : Boolean {
         return ssId == battlegroundId;
      }
      
      /**
       * Determines if the given solar system id is that of a battleground solar system.
       */
      public function isMiniBattleground(ssId:int) : Boolean {
         var ss:MSolarSystem = Collections.findFirstWithId(_solarSystems, ssId);
         return ss != null && ss.isMiniBattleground;
      }
      
      [Bindable(event="hasWormholesChange")]
      /**
       * Indicates if there are any wormholes in visible area of the galaxy.
       * 
       * <p><i><b>Metadata:</b></br>
       * [Bindable(event="hasWormholesChange")]
       * </i></p>
       */
      public function get hasWormholes() : Boolean {
         return _wormholes.length > 0;
      }
      
      [Bindable(event="resize")]
      public function get bounds() : MapArea {
         return _fowMatrixBuilder.getBounds();
      }
      
      [Bindable(event="resize")]
      public function get visibleBounds() : MapArea {
         return _fowMatrixBuilder.getVisibleBounds();
      }
      
      [Bindable(event="resize")]
      public function get offset() : Point {
         return _fowMatrixBuilder.getCoordsOffset();
      }
      
      [Bindable(event="resize")]
      public function get canBeExplored() : Boolean {
         return _fowMatrixBuilder.matrixHasVisibleTiles;
      }
      
      public function get fowMatrix() : Vector.<Vector.<Boolean>> {
         return _fowMatrixBuilder.getMatrix();
      }
      
      public function setFOWEntries(fowEntries:Vector.<MapArea>, units:IList) : void {
         _fowMatrixBuilder = new FOWMatrixBuilder(fowEntries, naturalObjects, units);
      }
      
      /**
       * Looks and returns for a solar system with a given id.
       * 
       * @param id
       * 
       * @return instance of <code>SolarSystem</code> or <code>null</code>
       * if a solar system with given id does not exists.
       */
      public function getSSById(id:int) : MSolarSystem {
         return Collections.findFirst(naturalObjects,
            function (ss:MSolarSystem) : Boolean {
               return ss.id == id;
            }
         );
      }
      
      /**
       * Returns solar system at the given coordinates or null if there is no solar system there.
       */
      public function getSSAt(x:int, y:int) : MSolarSystem {
         return MSolarSystem(getNaturalObjectAt(x, y));
      }
      
      /**
       * Returns all static object at the given coordinates.
       */
      public function getStaticObjectsAt(x:int, y:int) : Array {
         return getAllStaticObjectsAt(x, y);
      }

      /**
       * Will add solar system to this galaxy only if it is inside of the visible
       * visible galaxy area bounds (<code>visibleBounds</code>).
       *
       * @param ss solar system to add
       *
       * @return <code>true</code> if the solar system has been added or
       * <code>false</code> if it was outside of visible area bounds.
       */
      public function addSSToVisibleBounds(ss: MSolarSystem): Boolean {
         Objects.paramNotNull("ss", ss);
         const location: LocationMinimal = ss.currentLocation;
         if (visibleBounds.contains(location.x, location.y)) {
            const dispatchNewVisibleLocation: Boolean =
                     !locationIsVisible(location)
                        && hasEventListener(GalaxyEvent.NEW_VISIBLE_LOCATION);
            addObject(ss);
            _fowMatrixBuilder.rebuild();
            if (dispatchNewVisibleLocation) {
               dispatchEvent(
                  new GalaxyEvent(GalaxyEvent.NEW_VISIBLE_LOCATION, location)
               );
            }
            return true;
         }
         return false;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.MMap#mapType
       */
      override public function get mapType() : int {
         return MapType.GALAXY;
      }
      
      /**
       * Galaxy locations are not bounded to visible map square.
       */
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean {
         return location.type == LocationType.GALAXY && location.id == id;
      }
      
      /**
       * Basically does the same as <code>definesLocation()</code> but takes
       * fog of war into account.
       */
      public function locationIsVisible(location:LocationMinimal) : Boolean {
         if (definesLocation(location)) { 
            var x:int = location.x + offset.x;
            var y:int = location.y + offset.y;
            if (x >= 0 && x < bounds.width && y >= 0 && y < bounds.height)
               return fowMatrix[x][y];
         }
         return false;
      }
      
      protected override function get definedLocationType() : int {
         return LocationType.GALAXY;
      }
      
      protected override function setCustomLocationFields(location:Location) : void
      {
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function wormholes_collectionChangeHandler(event:CollectionEvent) : void {
         dispatchSimpleEvent(GalaxyEvent, GalaxyEvent.HAS_WORMHOLES_CHANGE);
      }

      private function dispatchApocalypseStartEventChangeEvent(e: MTimeEventEvent): void
      {
         dispatchSimpleEvent(
            GalaxyEvent, GalaxyEvent.APOCALYPSE_START_EVENT_CHANGE
         );
      }

      public function update(): void {
         if (_apocalypseStartEvent != null) {
            _apocalypseStartEvent.update();
         }
      }

      public function resetChangeFlags(): void {
         if (_apocalypseStartEvent != null) {
            _apocalypseStartEvent.resetChangeFlags();
         }
      }
   }
}
