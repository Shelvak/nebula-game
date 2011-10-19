package models.galaxy
{
   import flash.geom.Point;
   
   import models.galaxy.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.map.MapArea;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when galaxy dimensions have changed.
    * 
    * @eventType models.events.GalaxyEvent.RESIZE
    */
   [Event(name="resize", type="models.galaxy.events.GalaxyEvent")]
   
   /**
    * Dispatched when <code>hasWormholes</code> property have changed.
    * 
    * @eventType models.events.GalaxyEvent.RESIZE
    */
   [Event(name="hasWormholesChange", type="models.galaxy.events.GalaxyEvent")]
   
   public class Galaxy extends MMapSpace
   {
      private var _fowMatrixBuilder:FOWMatrixBuilder;
      
      public function Galaxy() {
         super();
         _wormholes = Collections.filter(naturalObjects, ff_wormholes);
         _wormholes.addEventListener(CollectionEvent.COLLECTION_CHANGE, wormholes_collectionChangeHandler);
         _solarSystems = Collections.filter(naturalObjects, ff_solarSystems);
         _solarSystemsWithPlayer = Collections.filter(naturalObjects, ff_solarSystemsWithPlayer);
      }
      
      public override function get cached() : Boolean {
         return ML.latestGalaxy != null && !ML.latestGalaxy.fake && id == ML.latestGalaxy.id;
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
      private function ff_solarSystems(ss:SolarSystem) : Boolean {
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
      
      private var _solarSystemsWithPlayer:ListCollectionView = new ListCollectionView();
      private function ff_solarSystemsWithPlayer(ss:SolarSystem) : Boolean {
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
      
      private var _wormholes:ListCollectionView;
      private function ff_wormholes(ss:SolarSystem) : Boolean {
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
      
      public function get hasMoreThanOneObject() : Boolean {
         return objects.length > 1;
      }
      
      /**
       * Determines if a solar system with given id, if exists, is a wormhole. If there is not such solar
       * system returns <code>false</code>.
       */
      public function isWormhole(ssId:int) : Boolean {
         var ss:SolarSystem = Collections.findFirstWithId(_wormholes, ssId);
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
         var ss:SolarSystem = Collections.findFirstWithId(_solarSystems, ssId);
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
         dispatchResizeEvent();
      }
      
      /**
       * Looks and returns for a solar system with a given id.
       * 
       * @param id
       * 
       * @return instance of <code>SolarSystem</code> or <code>null</code>
       * if a solar system with given id does not exists.
       */
      public function getSSById(id:int) : SolarSystem {
         return Collections.findFirst(naturalObjects,
            function (ss:SolarSystem) : Boolean {
               return ss.id == id;
            }
         );
      }
      
      /**
       * Looks for a solar system, pulsar or wormhole at given coordinates and returns it
       * if successful.
       */
      public function getSSAt(x:int, y:int) : SolarSystem {
         return Collections.findFirst(naturalObjects,
            function (ss:SolarSystem) : Boolean {
               return ss.x == x && ss.y == y;
            }
         );
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int {
         return MapType.GALAXY;
      };
      
      /**
       * Galaxy locations are not bounded to visible map square.
       */
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean {
         return location.type == LocationType.GALAXY && location.id == id;
      }
      
      /**
       * Basicly does the same as <code>definesLocation()</code> but takes fog of war into account.
       */
      public function locationIsVisible(location:LocationMinimal) : Boolean {
         if (definesLocation(location)) {
            var fowMatrix:Vector.<Vector.<Boolean>> = _fowMatrixBuilder.getMatrix(); 
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
      
      private function dispatchResizeEvent() : void {
         dispatchSimpleEvent(GalaxyEvent, GalaxyEvent.RESIZE);
      }
   }
}
