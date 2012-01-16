package models.solarsystem
{
   import config.Config;

   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.InviteActionParams;

   import controllers.ui.NavigationController;

   import flash.display.BitmapData;

   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;
   import models.player.PlayerMinimal;

   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.locale.Localizer;


   [Bindable]
   public class MSolarSystem extends BaseModel implements IMStaticSpaceObject
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

      /* ############# */
      /* ### OWNER ### */
      /* ############# */

      private var _player:PlayerMinimal;
      [Required]
      /**
       * Player that owns this solar system. May be <code>null</code>.
       */
      public function set player(value: PlayerMinimal): void {
         if (_player != value) {
            _player = value;
         }
      }
      public function get player(): PlayerMinimal {
         return _player;
      }

      public function get canInviteOwnerToAlliance(): Boolean {
         return _player != null
                   && !metadata.alliancePlanets
                   && !_player.equals(ML.player)
                   &&  ML.player.canInviteToAlliance;
      }

      public function inviteOwnerToAlliance(): void {
         if (canInviteOwnerToAlliance) {
            new AlliancesCommand(
               AlliancesCommand.INVITE, new InviteActionParams(_player.id)
            ).dispatch();
         }
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
         return !isShielded
                   || ML.player.equals(_player)
                   || metadata.alliancePlanets;
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

      /**
       * Returns <code>true</code> if this solar system is shielded.
       */
      public function get isShielded(): Boolean {
         return kind == SSKind.NORMAL && _player != null;
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
         return id % Config.getSolarSystemVariations();
      }

      [Bindable(event="willNotChange")]
      public function get imageData(): BitmapData {
         if (isMiniBattleground) {
            return IMG.getImage(AssetNames.MINI_BATTLEGROUND_IMAGE_NAME);
         }
         else if (isWormhole || isGlobalBattleground) {
            return IMG.getImage(AssetNames.WORMHOLE_IMAGE_NAME);
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