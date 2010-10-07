package models.unit
{
   import config.Config;
   
   import flash.display.BitmapData;
   import flash.events.Event;
   
   import models.BaseModel;
   import models.Owner;
   import models.building.Building;
   import models.location.Location;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.UnitUpgradable;
   import models.parts.Upgradable;
   import models.unit.events.UnitEvent;
   
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   [ResourceBundle ('Units')]
   
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
      
      [Bindable (event="willNotChange")]
      public function get deploysTo(): String
      {
         return Config.getUnitDeploysTo(type);
      }
      
      public function get storage(): int
      {
         return Config.getUnitStorage(type);
      }
      
      public function get volume(): int
      {
         return Config.getUnitVolume(type);
      }
      
      
      [Required]
      /**
       * How many volume this unit has stored in
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 0
       */
      public var stored:int = 0;
      
      
      public static function unitIsValid(unitType: String = null):Boolean
      {
         return Requirement.isValid(Config.getUnitRequirements(unitType));
      }
      
      
      private static function getUnitTitle(type: String): String
      {
         return ResourceManager.getInstance().getString('Units', type + ".name");
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
         return ResourceManager.getInstance().getString('Units', type + '.about');
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
         var oldSquadronId: int = _squadronId;
         _squadronId = value;
         dispatchSquadronIdChangeEvent(oldSquadronId);
         dispatchPropertyUpdateEvent("squadronId", value);
         dispatchPropertyUpdateEvent("isMoving", isMoving);
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
      [Optional]
      /**
       * Owner of this unit: one of constants in <code>Owner</code> class.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional]</i></p>
       * 
       * @default Owner.UNDEFINED
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
      
      
      [Required]
      public var xp: String;
      
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
         dispatchEvent(new Event('unitStanceChange'));
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
      
      private function dispatchSquadronIdChangeEvent(oldSquadronId: int): void
      {
         dispatchEvent(new UnitEvent(UnitEvent.SQUADRON_ID_CHANGE, oldSquadronId));
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", type: " + type + ", squadronId: " + squadronId +
                ", owner: " + owner + ", location: " + location + "]";
      }
      
   }
}