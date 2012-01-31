package models.unit
{
   import config.Config;

   import controllers.objects.ObjectClass;

   import flash.display.BitmapData;
   
   import models.BaseModel;
   import models.Owner;
   import models.building.Building;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.UnitUpgradable;
   import models.parts.Upgradable;
   import models.player.PlayerMinimal;
   import models.resource.Resource;
   import models.unit.events.UnitEvent;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;

   import utils.DateUtil;

   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   
   [Bindable]
   public class Unit extends BaseModel implements IUpgradableModel
   {
      public static const JUMP_IN_SS: String = "move.solarSystem.hopTime";
      public static const JUMP_IN_GALAXY: String = "move.galaxy.hopTime";
      public static const JUMP_SPEED_MOD: String = "movementTimeDecrease";


      public static function sortByHp(list: ListCollectionView): void
      {
         if (list)
         {
            list.sort = new Sort();
            list.sort.fields = [
               new SortField('hasStorage', false, true),
               new SortField('hidden', false, true),
               new SortField('type'),
               new SortField('transporterStorage', false, true, true),
               new SortField('hp', false, true, true),
               new SortField('id', false, false, true)
            ];
            list.refresh();
         }
      }

      public static function getJumpTime(formula: String, type: String,
                             level: int): String
      {
         var mod: Number = ML.technologies.getTechnologiesPropertyMod(
             JUMP_SPEED_MOD, ObjectClass.UNIT + '/' +
                         StringUtil.camelCaseToUnderscore(type)
         );
         return DateUtil.secondsToHumanString(
                 Math.round(StringUtil.evalFormula(formula,
                        {"level": level}) * (100 - mod) / 100));
      }

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
      
      public static function getXpMax(type: String, level: int): int
      {
         return Math.round(StringUtil.evalFormula(Config.getUnitXpNeeded(type),
            {'level': level}));
      }
      
      public static function getMovementSpeedUpCredsCost(
         percentage: Number, hopCount: int): int
      {
         return Math.max(
            0, 
            Math.min(
               Math.round(
                  StringUtil.evalFormula(Config.getMovementSpeedUpCredsCost(),
                     {
                        'percentage': percentage,
                        'hop_count': hopCount
                     })
               ),
               Config.getMovementSpeedUpMaxCredsCost()
            )
         );
      }
      
      public static function getStoredResourcesPercent(
         _storage: uint, _metal: uint, _energy: uint, _zetium: uint
      ): uint
      {
         return Math.round(100 * Resource.getResourcesVolume(_metal, _energy, _zetium)/_storage);
      }
      
      public static function getStoredUnitsPercent(
         _storage: uint, _stored: uint, _metal: uint, _energy: uint,
         _zetium: uint
      ): int
      {
         return Math.round(100 * (_stored - Resource.getResourcesVolume(_metal, _energy, _zetium))/_storage);
      }
      
      public function get units(): ListCollectionView
      {
         return Collections.filter(ML.units, function (item: Unit): Boolean
         {
            return item.location.type == LocationType.UNIT;
         });
      }
      
      public function get damagePercentage(): Number
      {
         return (hpMax - hp)/hpMax;
      }
      
      public function get alivePercentage(): Number
      {
         return hp/hpMax;
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
      
      private var _metal: uint = 0;
      private var _energy: uint = 0;
      private var _zetium: uint = 0;

      [Bindable (event="metalAmountChange")]
      [Optional]
      public function set metal(value: uint): void
      {
         _metal = value;
         var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
         if (LS.target == this || LS.location == this)
         {
            LS.dispatchRefreshMaxStorageEvent();
         }
         dispatchMetalChangeEvent()
      }

      public function get metal(): uint
      {
         return _metal;
      }

      [Bindable (event="energyAmountChange")]
      [Optional]
      public function set energy(value: uint): void
      {
         _energy = value;
         var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
         if (LS.target == this || LS.location == this)
         {
            LS.dispatchRefreshMaxStorageEvent();
         }
         dispatchEnergyChangeEvent();
      }

      public function get energy(): uint
      {
         return _energy;
      }

      [Bindable (event="zetiumAmountChange")]
      [Optional]
      public function set zetium(value: uint): void
      {
         _zetium = value;
         var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
         if (LS.target == this || LS.location == this)
         {
            LS.dispatchRefreshMaxStorageEvent();
         }
         dispatchZetiumChangeEvent()
      }

      public function get zetium(): uint
      {
         return _zetium;
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
      
      [Bindable(event="willNotChange")]
      public function get volume(): int
      {
         return Config.getUnitVolume(type);
      }

      public function get hasStorage(): Boolean
      {
         return ML.technologies.getUnitStorage(type, level) > 0;
      }
      
      public function get transporterStorage(): int
      {
         return ML.technologies.getUnitStorage(type, level);
      }
      
      [Bindable (event="storedAmountChange")]
      [Optional]
      /**
       * How many volume this unit has stored in
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public function set stored(value: int): void
      {
         if (_stored != value)
         {
            _stored = value;
            var LS: MCLoadUnloadScreen = MCLoadUnloadScreen.getInstance();
            if (LS.target == this || LS.location == this)
            {
               LS.dispatchRefreshMaxStorageEvent();
            }
            dispatchStoredChangeEvent();
         }
      }
      
      public function get stored(): int
      {
         return _stored;
      }
      private var _stored:int = 0;
      
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
      
      
      /**
       * <p>After calling this method you won't be able to access any upgradable properties.</p>
       * 
       * @inheritDoc
       */
      public function cleanup() : void
      {
         if (_upgradePart)
         {
            _upgradePart.cleanup();
            _upgradePart = null;
         }
      }
      
      
      private var _upgradePart:UnitUpgradable;
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
      
      [Bindable (event="willNotChange")]
      public function get maxLevel(): int
      {
         return Config.getUnitMaxLevel(type);
      }
      
      [Optional]
      public var xp: int;
      
      
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
      public var location:LocationMinimal = null;
      
      
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
      public var playerId:int = 0;
      
      
      [Optional]
      [SkipProperty]
      /**
       * A player this unit belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [SkipProperty]</i></p>
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
      
      private var _stance: int;
      [Required]
      [Bindable (event="unitStanceChange")]
      public function set stance(value: int): void
      {
         _stance = value;
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

      [Optional]
      public var hidden: Boolean = false;
      
      
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

      private function dispatchStoredChangeEvent() : void
      {
         if (hasEventListener(UnitEvent.STORED_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.STORED_CHANGE));
         }
      }

      private function dispatchMetalChangeEvent() : void
      {
         if (hasEventListener(UnitEvent.METAL_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.METAL_CHANGE));
         }
      }

      private function dispatchEnergyChangeEvent() : void
      {
         if (hasEventListener(UnitEvent.ENERGY_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.ENERGY_CHANGE));
         }
      }

      private function dispatchZetiumChangeEvent() : void
      {
         if (hasEventListener(UnitEvent.ZETIUM_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.ZETIUM_CHANGE));
         }
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", type: " + type + ", squadronId: " + squadronId +
            ", owner: " + owner + ", palyerId: " + playerId + ", location: " + location + "]";
      }
      
   }
}