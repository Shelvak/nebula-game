package models.unit
{
   import config.Config;
   
   import flash.display.BitmapData;
   
   import models.BaseModel;
   import models.Owner;
   import models.building.Building;
   import models.location.Location;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.UnitUpgradable;
   import models.parts.Upgradable;
   import models.player.PlayerMinimal;
   import models.unit.events.UnitEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.Localizer;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   [Bindable]
   public class Unit extends BaseModel implements IUpgradableModel
   {
      public static function getValidUnits(facility: Building): ArrayCollection
      {
         var resultList: ArrayCollection = new ArrayCollection();
         for each (var rawUnit: String in facility.constructableItems)
         {
            var unitType: String = rawUnit.split('/')[1];
            if (unitIsValid(unitType))
            {
               resultList.addItem({'type': unitType, 'facility': facility});
            }
            
         }
         return resultList;
      }
      
      public static function getAllUnits(facility: Building): ArrayCollection
      {
         var resultList: ArrayCollection = new ArrayCollection();
         for each (var rawUnit: String in facility.constructableItems)
         {
            resultList.addItem({'type': rawUnit.split('/')[1], 'facility': facility});
         }
         return resultList;
      }
      
      public function get hasGuns(): Boolean
      {
         var guns: Array = Config.getUnitGuns(type);
         return ((guns != null) && (guns.length > 0));
      }
      
      [Bindable (event="willNotChange")]
      public function get deploysTo(): String
      {
         return Config.getUnitDeploysTo(type);
      }
      
      public static function getVolume(units: Array): int
      {
         var volumeTotal: int = 0;
         for each (var unit: Unit in units)
         {
            volumeTotal += unit.volume;
         }
         return volumeTotal;
      }
      
      [Bindable (event="willNotChange")]
      public function get storage(): int
      {
         return Config.getUnitStorage(type);
      }
      
      public function get volume(): int
      {
         return Config.getUnitVolume(type);
      }
      
      
      [Optional]
      /**
       * How many volume this unit has stored in
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public var stored:int = 0;
      
      /**
       * for drawing double progressbar in units screen (storage) 
       */      
      public var selectedVolume: int = 0;
      
      
      public static function unitIsValid(unitType: String = null):Boolean
      {
         return Requirement.isValid(Config.getUnitRequirements(unitType));
      }
      
      
      private static function getUnitTitle(type: String): String
      {
         return Localizer.string('Units', type + ".name");
      }
      
      [Bindable(event="willNotChange")]
      public function get name(): String
      {
         return getUnitTitle(type);
      }
      
      
      include "../mixins/upgradableProxyProps.as"; 
      include "../mixins/commonUnitProps.as";
      
      
      public function Unit()
      {
         _upgradePart = new UnitUpgradable(this);
      };
      
      
      private var _upgradePart:*;
      [Bindable(event="willNotChange")]
      public function get upgradePart() : Upgradable
      {
         return _upgradePart;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get title(): String
      {
         return getUnitTitle(type);
      }
      
      
      public function get description(): String
      {
         return Localizer.string('Units', type + '.about');
      };
      
      
      public function getInfoData(): Object{
         return Config.getUnitProperties(type);
      }
      
      
      public function get maxLevel(): int
      {
         return Config.getUnitMaxLevel(type);
      }
      
      
      private var _squadronId:int = 0;
      [Required(alias="routeId")]
      [Bindable(event="squadronIdChange")]
      /**
       * Id of a squadron this unit belongs to. Makes sense only if this unit is a space unit
       * and is actually in space.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="routeId")]<br/>
       * [Bindable(event="squadronIdChange")]</i></p>
       */
      public function set squadronId(value:int) : void
      {
         var oldSquadronId:int = _squadronId;
         var oldIsMoving:Boolean = isMoving;
         _squadronId = value;
         dispatchSquadronIdChangeEvent(oldSquadronId);
         dispatchPropertyUpdateEvent("squadronId", value, oldSquadronId);
         dispatchPropertyUpdateEvent("isMoving", isMoving, oldIsMoving);
      }
      /**
       * @private
       */
      public function get squadronId() : int
      {
         return _squadronId;
      }
      
      
      [Optional]
      /**
       * @default null 
       */
      public var location:Location = null;
      
      
      [Bindable(event="squadronIdChange")]
      /**
       * Indicates if this unit is traveling through space.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="squadronIdChange")]</i></p>
       */
      public function get isMoving() : Boolean
      {
         return squadronId > 0;
      }
      
      
      [SkipProperty]
      [Optional(alias="status")]
      /**
       * Owner of this unit: one of constants in <code>Owner</code> class.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional(alias="status")]</i></p>
       * 
       * @default Owner.PLAYER
       */
      public var owner:int = Owner.PLAYER;
      
      
      [Required]
      /**
       * Id of a player this unit belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 0
       */
      public var playerId:int = PlayerMinimal.NO_PLAYER_ID;
      
      
      [Optional]
      /**
       * A player this unit belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default null
       */
      public var player:PlayerMinimal = null;
      
      
      [Required]
      public var flank: int;
      
      public static const STANCE_WORD: String = 'stance';
      
      public static const STANCE_NEUTRAL: int = 0;
      public static const STANCE_DEFENSIVE: int = 1;
      public static const STANCE_AGGRESSIVE: int = 2;
      
      
      public var newStance: int;
      private var _stance: int;
      [Required]
      [Bindable (event="unitStanceChange")]
      public function set stance(value: int): void
      {
         _stance = value;
         newStance = value;
         dispatchStanceChangeEvent();
         dispatchPropertyUpdateEvent("stance", value);
      }
      /**
       * @private
       */
      public function get stance(): int
      {
         return _stance;
      }
      
      
      [Required]
      /**
       * Mod which reduces construction/upgrade time for this unit. 
       */      
      public var constructionMod: Number = 0;
      
      public function get imageData() : BitmapData
      {
         return ImagePreloader.getInstance().getImage(AssetNames.getUnitImageName(type));
      }
      
      public function get imageWidth() : Number
      {
         return imageData.width;
      }
      
      public function get imageHeight() : Number
      {
         return imageData.height;
      }
      
      private function dispatchSquadronIdChangeEvent(oldSquadronId:int) : void
      {
         if (hasEventListener(UnitEvent.SQUADRON_ID_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.SQUADRON_ID_CHANGE, oldSquadronId));
         }
      }
      
      
      private function dispatchStanceChangeEvent() : void
      {
         if (hasEventListener(UnitEvent.STANCE_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.STANCE_CHANGE));
         }
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", type: " + type + ", squadronId: " + squadronId +
                ", owner: " + owner + ", palyerId: " + playerId + ", location: " + location + "]";
      }
      
   }
}