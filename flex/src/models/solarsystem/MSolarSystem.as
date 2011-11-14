package models.solarsystem
{
   import config.Config;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   
   import interfaces.IUpdatable;

   import models.BaseModel;

   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;
   import models.map.MapType;
   import models.solarsystem.events.MSolarSystemEvent;
   
   import mx.collections.ListCollectionView;
   
   import namespaces.change_flag;
   
   import utils.DateUtil;
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   
   /**
    * Dispatched when <code>shieldOwnerId</code> property changes.
    * 
    * @eventType models.solarSystem.events.MSolarSystemEvent.SHIELD_OWNER_CHANGE
    */
   [Event(name="shieldOwnerChange", type="models.solarsystem.events.MSolarSystemEvent")]
   
   /**
    * Dispatched when <code>shieldEndsAt</code> property changes.
    * 
    * @eventType models.solarSystem.events.MSolarSystemEvent.SHIELD_ENDS_AT_CHANGE
    */
   [Event(name="shieldEndsAtChange", type="models.solarsystem.events.MSolarSystemEvent")]
   
   /**
    * Dispatched when <code>shieldEndsIn</code> property changes.
    * 
    * @eventType models.solarSystem.events.MSolarSystemEvent.SHIELD_ENDS_IN_CHANGE
    */
   [Event(name="shieldEndsInChange", type="models.solarsystem.events.MSolarSystemEvent")]
   
   [Bindable]
   public class MSolarSystem extends BaseModel implements IMStaticSpaceObject, IUpdatable
   {
      public static const IMAGE_WIDTH: Number = 64;
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      public static const COMPONENT_WIDTH:int = 96;
      public static const COMPONENT_HEIGHT:int = COMPONENT_WIDTH;
      
      
      private function get NAV_CTRL(): NavigationController{
         return NavigationController.getInstance();
      }
      
      
      public function MSolarSystem() {
         super();
      }
      
      
      private var _importantObjects:ListCollectionView;
      private function ff_importantObjects(object:MSSObject) : Boolean {
         return object.isPlanet || object.isJumpgate;
      }
      [Bindable(event="willNotChange")]
      /**
       * Important to player objects (planets and jumpgates).
       */
      public function get importantObjects() : ListCollectionView {
         return _importantObjects;
      }

      public function get cached(): Boolean {
         if (ML.latestSSMap == null) {
            return false;
         }
         if (ML.latestSSMap != null && !ML.latestSSMap.fake) {
            if (id == ML.latestSSMap.id) {
               return true;
            }
            // check if both solar systems are wormholes
            if (ML.latestGalaxy.hasWormholes
                   && (isWormhole || isGlobalBattleground)
                   && ML.latestSSMap.solarSystem.isGlobalBattleground) {
               return true;
            }
         }
         return false;
      }

      [Bindable(event="willNotChange")]
      /**
       * Name of this solar system.
       *
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       */
      public function get name(): String {
         if (isMiniBattleground) {
            return getString("label.pulsar", [id]);
         }
         return (isWormhole || isGlobalBattleground)
                   ? getString("label.wormhole")
                   : NameResolver.resolveSolarSystem(id);
      }

      [Bindable(event="willNotChange")]
      /**
       * Name of this solar system used in navigator.
       *
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       */
      public function get navigatorName(): String {
         var name: String = "";
         if (isMiniBattleground) {
            name = getString("label.pulsar", [id]);
         }
         else if (isWormhole || isGlobalBattleground) {
            return getString("label.wormhole");
         }
         else {
            name = NameResolver.resolveSolarSystem(id);
         }

         return name + " (" + x + ":" + y + ")";
      }

      [Required]
      /**
       * Horizontal coordinate (in tiles) of a solar system in galaxy map.
       */
      public var x: Number = 0;

      [Required]
      /**
       * Vertical coordinate (in tiles) of a solar system in galaxy map.
       */
      public var y: Number = 0;

      public function get galaxyId(): int {
         return ML.player.galaxyId;
      }
      
      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         if (isShielded) {
            change_flag::shieldEndsIn = true;
            dispatchSimpleEvent(MSolarSystemEvent,
                                MSolarSystemEvent.SHIELD_ENDS_IN_CHANGE);
         }
      }

      public function resetChangeFlags(): void {
         change_flag::shieldEndsIn = false;
         change_flag::shieldEndsAt = false;
         change_flag::shieldOwnerId = false;
      }
      
      
      /* ######################## */
      /* ### IStaticMAPObject ### */
      /* ######################## */


      [Bindable(event="willNotChange")]
      /**
       * Location of the solar system in a galaxy.
       */
      public function get currentLocation(): LocationMinimal {
         var loc: LocationMinimal = new LocationMinimal();
         loc.type = LocationType.GALAXY;
         loc.id = galaxyId;
         loc.x = x;
         loc.y = y;
         return loc;
      }

      [Bindable(event="shieldOwnerChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * </p>
       *
       * @inheritDoc
       */
      public function get isNavigable(): Boolean {
         return !isDead && (!isShielded || _shieldOwnerId == ML.player.id);
      }

      public function navigateTo(): void {
         NAV_CTRL.toSolarSystem(id);
      }

      public function get objectType(): int {
         return MMapSpace.STATIC_OBJECT_NATURAL;
      }

      [Bindable(event="willNotChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       *
       * @inheritDoc
       */
      public function get componentWidth(): int {
         return COMPONENT_WIDTH;
      }

      [Bindable(event="willNotChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       *
       * @inheritDoc
       */
      public function get componentHeight(): int {
         return COMPONENT_HEIGHT;
      }


      /* ############## */
      /* ### SHIELD ### */
      /* ############## */

      [Bindable(event="shieldOwnerChange")]
      /**
       * Returns <code>true</code> if this solar system is shielded.
       *
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * </p>
       */
      public function get isShielded(): Boolean {
         return _shieldOwnerId > 0;
      }

      change_flag var shieldOwnerId: Boolean = true;
      private var _shieldOwnerId: int = 0;
      [Bindable(event="shieldOwnerChange")]
      [Optional]
      /**
       * Id of a shield owner. <code>0</code> if this solar system is not shielded.
       * Default is <code>0</code>.
       *
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * [Optional]
       * </p>
       */
      public function set shieldOwnerId(value: int): void {
         if (_shieldOwnerId != value) {
            _shieldOwnerId = value;
            dispatchSimpleEvent(MSolarSystemEvent,
                                MSolarSystemEvent.SHIELD_OWNER_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get shieldOwnerId(): int {
         return _shieldOwnerId;
      }

      change_flag var shieldEndsAt: Boolean = true;
      private var _shieldEndsAt: Date = null;
      [Bindable(event="shieldEndsAtChange")]
      [Optional]
      /**
       * Time when the shield expires if the shield is preset at all. If solar
       * system is not shielded, this property is <code>null</code>. Default
       * is <code>null</code>.
       */
      public function set shieldEndsAt(value: Date): void {
         if (_shieldEndsAt != value) {
            _shieldEndsAt = value;
            dispatchSimpleEvent(MSolarSystemEvent,
                                MSolarSystemEvent.SHIELD_ENDS_AT_CHANGE);
         }
      }

      /**
       * @private
       */
      public function get shieldEndsAt(): Date {
         return _shieldEndsAt;
      }

      change_flag var shieldEndsIn: Boolean = true;
      [Bindable(event="shieldEndsInChange")]
      /**
       * Number of seconds this solar system will be shielded for.
       * <code>0</code> if solar system is not shielded.
       *
       * <p>Metadata:<br/>
       * [Bindable(event="shieldEndsInChange")]
       * </p>
       */
      public function get shieldEndsIn(): int {
         if (!isShielded || _shieldEndsAt == null) {
            return 0
         }
         return Math.max(0, (shieldEndsAt.time - DateUtil.now) / 1000);
      }


      /* ############ */
      /* ### KIND ### */
      /* ############ */

      [Required]
      /**
       * Kind of this solar system (one of constants in <code>SSKind</code>).
       *
       * <p>Metadata:</br>
       * [Required]
       * </p>
       */
      public var kind: int = SSKind.NORMAL;

      /**
       * Indicates if this is a wormhole to a global battleground solar system (one in whole galaxy).
       */
      public function get isWormhole(): Boolean {
         return kind == SSKind.WORMHOLE;
      }

      [Bindable(event="willNotChange")]
      public function get isDead(): Boolean {
         return kind == SSKind.DEAD_STAR;
      }

      /**
       * Indicates if this solar systems is global battleground system. Wormholes are not battlegrounds: just
       * gates to global battleground.
       */
      public function get isGlobalBattleground(): Boolean {
         return id == ML.latestGalaxy.battlegroundId;
      }

      public function get isBattleground(): Boolean {
         return kind == SSKind.BATTLEGROUND;
      }

      /**
       * Indicates if this solar system is a mini-battleground system. Those are placed all over the galaxy
       * as playground for players around them.
       */
      public function get isMiniBattleground(): Boolean {
         return kind == SSKind.BATTLEGROUND && !isGlobalBattleground;
      }

      [Bindable(event="willNotChange")]
      /**
       * Variation of an icon that visualizes a solar system in a galaxy.
       */
      public function get variation(): int {
         return isDead
                   ? id % 3
                   : id % Config.getSolarSystemVariations();
      }

      [Bindable(event="willNotChange")]
      public function get imageData(): BitmapData {
         if (isMiniBattleground) {
            return IMG.getImage(AssetNames.MINI_BATTLEGROUND_IMAGE_NAME);
         }
         else if (isWormhole || isGlobalBattleground) {
            return IMG.getImage(AssetNames.WORMHOLE_IMAGE_NAME);
         }
         else if (isDead) {
            return IMG.getImage(AssetNames.getDeadStarImageName(variation));
         }
         else {
            return IMG.getImage(AssetNames.getSSImageName(variation));
         }
      }

      /**
       * Metadata of the solar system.
       *
       * @default default instance of <code>MSSMetadata</code>.
       *
       * @see models.solarsystem.MSSMetadata
       */
      public var metadata: MSSMetadata = new MSSMetadata();
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString(): String {
         return "[class: " + className
                   + ", id: " + id
                   + ", x: " + x
                   + ", y: " + y
                   + ", kind:" + kind
                   + ", metadata: " + metadata + "]";
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getString(property:String, params:Array = null) : String {
         return Localizer.string("Galaxy", property, params);
      }
   }
}