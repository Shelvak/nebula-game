package models.building
{
   // Explicitly state all building classes here that are not referenced directly anywhere in the code.
   MetalExtractor;
   ZetiumExtractor;
   GeothermalPlant;
   
   
   import config.Config;
   
   import flash.display.BitmapData;
   
   import models.ModelsCollection;
   import models.building.events.BuildingEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.parts.BuildingUpgradable;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.Upgradable;
   import models.parts.events.UpgradeEvent;
   import models.planet.PlanetObject;
   import models.tile.TileKind;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.resources.ResourceManager;
   
   import utils.StringUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   /**
    * Dispatched when <code>level</code> property has changed.
    * 
    * @eventType models.parts.events.UpgradeEvent.LVL_CHANGE
    */
   [Event(name="lvlChange", type="models.parts.events.UpgradeEvent")]
   
   /**
    * Dispatched when any of positioning properties - and as a result dimension (size)
    * properties - have changed.
    * 
    * @eventType models.building.events.BuildingEvent.DIMENSION_CHANGE
    */
   [Event (name="dimensionChange", type="models.building.events.BuildingEvent")]
   
   /**
    * Dispatched when any health points properties - and as a result <code>isDamaged</code>
    * - have changed.
    * 
    * @eventType models.building.events.BuildingEvent.HP_CHANGE
    */
   [Event (name="hpChange", type="models.building.events.BuildingEvent")]
   
   
   /**
    * Generic building of a game.
    */
   [Bindable]
   public class Building extends PlanetObject implements IUpgradableModel
   {
      /**
       * Mandatory gap between buildings.
       */
      public static const GAP_BETWEEN:int = 1;
      
      //states constants
      public static const INACTIVE: int = 0;
      public static const ACTIVE: int = 1;
      public static const WORKING: int = 2;
      
      
      include "../mixins/upgradableProxyProps.as"; 
      
      
      public function Building()
      {
         _upgradePart = new BuildingUpgradable(this);
         _upgradePart.addEventListener(
            UpgradeEvent.UPGRADE_PROGRESS,
            upgradePart_upgradeProgressHandler
         );
         _upgradePart.addEventListener(UpgradeEvent.LVL_CHANGE,
            upgradePart_lvlChangeHandler);
      }
      
      public var unitDeployed: Unit = null;
      
      public var selectedCount: int = 1;
      
      private var _constructionQueueEntries: ModelsCollection = new ModelsCollection();
      
      [Bindable (event="buildingQueryChange")]
      public function getQueueEmptySpace(): int
      {
         var count: int = 0;
         for each (var entry: ConstructionQueueEntry in constructionQueueEntries)
         count += entry.count;
         return Config.getBuildingMaxQueue(type) - count;
      }
      
      [ArrayElementType ("models.constructionqueueentry.ConstructionQueueEntry")]
      [Optional]
      public function set constructionQueueEntries(value: ModelsCollection): void
      {
         _constructionQueueEntries = value;
         dispatchQueryChangeEvent();
      }
      
      [Bindable (event="buildingQueryChange")]
      public function get constructionQueueEntries(): ModelsCollection
      {
         return _constructionQueueEntries;
      }
      
      
      private var _upgradePart:BuildingUpgradable;
      [Bindable(event="willNotChange")]
      public function get upgradePart() : Upgradable
      {
         return _upgradePart;
      }
      
      [Required]
      public var planetId: int = 0;
      
      private var _type: String = null;
      [Required]
      public function set type(v:String) : void
      {
         _type = v;
         dispatchImageChangeEvent();
         dispatchTypeChangeEvent();
      }
      
      [Bindable (event="buildingTypeChange")]
      public function get type() : String
      {
         return _type;
      }
      
      
      [Bindable(event="modelIdChange")]
      public function get isGhost() : Boolean
      {
         return id == 0;
      }
      
      
      public function get isExtractor() : Boolean
      {
         return type == BuildingType.GEOTHERMAL_PLANT ||
                type == BuildingType.METAL_EXTRACTOR ||
                type == BuildingType.ZETIUM_EXTRACTOR;
      }
      
      
      [Bindable (event="buildingTypeChange")]
      public function get constructableItems() : ArrayCollection
      {
         return Config.getBuildingConstructableItems(type);
      }
      
      
      [Bindable(event="planetObjectImageChange")]
      override public function get imageData() :BitmapData
      {
         return ImagePreloader.getInstance().getImage(AssetNames.getBuildingImageName(type));
      }
      
      [Bindable (event="buildingTypeChange")]
      public function get npc(): Boolean
      {
         return Config.getBuildingNpc(type);
      }
      
      [Required]
      /**
       *state means:
       * 0 - inactive
       * 1 - active
       * 2 - working 
       */
      public var state: int = 0;
      
      /**
       * Id of the constructable item which this building is currently constructing
       */      
      [Required]
      public var constructableId: int = 0;
      
      /**
       * Id of the constructor which is curently constructing this building 
       */      
      public var constructorId: int = 0;
      
      [Required]
      public var constructableType: String = null;
      
      private var _hp: int = 0;
      [Required]
      [Bindable(event="buildingHpChange")]
      public function get hp() : int
      {
         return _hp;
      }
      public function set hp(v:int) : void
      {
         _hp = v;
         dispatchHpChangeEvent();
      }
      /**
       * Increments <code>hp</code> by a given value. If <code>hp</code> then exceeds
       * <code>hpMax</code>, <code>hp</code> is set to <code>hpMax</code>.
       */
      public function incrementHp(value:int) : void
      {
         var newHp:int = hp + value;
         if (newHp > maxHp)
         {
            newHp = maxHp;
         }
         hp = newHp;
      }
      
      
      [Required]
      /**
       * Proxy property to <code>upgradePart.hpRemainder</code>
       */
      public function set hpRemainder(value:int) : void
      {
         _upgradePart.hpRemainder = value;
      }
      /**
       * @private
       */
      public function get hpRemainder() : int
      {
         return _upgradePart.hpRemainder;
      }
      
      
      
      [Bindable(event="hpMaxChange")]
      public function get hpMax() : int
      {
         var levelToSet: int = upgradePart.level;
         if (upgradePart.upgradeEndsAt != null)
            levelToSet++;
         
         return StringUtil.evalFormula(Config.getBuildingHp(type), {'level':levelToSet});
      }
      
      [Bindable(event="hpMaxChange")]
      public function get maxHp(): int
      {
         return hpMax;
      }
      
      
      /**
       * Returns <strong><code>true</code></strong>.
       * 
       * @see models.planet.PlanetObject#isBlocking
       */
      override public function get isBlocking() : Boolean
      {
         return true;
      }
      
      
      public function get description(): String
      {
         return ResourceManager.getInstance().getString('Buildings', type + '.about');
      };
      
      [Bindable(event="buildingHpChange")]
      /**
       * Indicates if this building is damaged (<code>hp < hpMax</code>). 
       */
      public function get isDamaged() : Boolean
      {
         return hp < maxHp;
      }
      
      
      [Optional]
      public var hpRate: int = 0;
      [Required]
      public var armorMod: int = 0;
      [Required]
      /**
       * Mod which reduces construction/upgrade time for this building. 
       */      
      public var constructionMod: Number = 0;
      [Required]
      /**
       * Mod which reduces construction/upgrade time for constructables it constructs.  
       */      
      public var constructorMod: Number = 0;
      public var bonuses:BuildingBonuses = new BuildingBonuses();
      
      [Required]
      public var energyMod: int = 0;
      
      /**
       * 
       * @param constructableType
       * @return either this building can construct constructableType objects
       * 
       */      
      public function isConstructor(constructableType: String): Boolean
      {
         var constructors :Array = Config.getConstructors(constructableType);
         return (constructors.indexOf(type) != -1);
      } 
      
      public function get maxQueryItems(): int
      {
         return Config.getBuildingMaxQueue(type);
      }
      
      
      
      [Bindable (event="levelChange")]
      public function get metalRate(): Number
      {
         return(
            StringUtil.evalFormula(Config.getBuildingMetalGenerateRate(type), 
               {"level": level}) -
            StringUtil.evalFormula(Config.getBuildingMetalUseRate(type), 
               {"level": level}))
         
      };
      
      [Bindable (event="levelChange")]
      public function get energyRate(): Number
      {
         var a: Number = Math.round(StringUtil.evalFormula(Config.getBuildingEnergyGenerateRate(type), 
            {"level": level})* (1 + (energyMod/100)));
         var b: Number = StringUtil.evalFormula(Config.getBuildingEnergyUseRate(type), 
            {"level": level});
         return(a-b);
         
      };
      
      [Bindable (event="levelChange")]
      public function get radarStrength(): Number
      {
         return StringUtil.evalFormula(Config.getBuildingRadarStrength(type), {"level": level});
      }
      
      [Bindable (event="levelChange")]
      public function get zetiumRate(): Number
      {
         return(
            StringUtil.evalFormula(Config.getBuildingZetiumGenerateRate(type), 
               {"level": level}) -
            StringUtil.evalFormula(Config.getBuildingZetiumUseRate(type), 
               {"level": level}))
         
      };
      
      [Bindable (event="levelChange")]
      public function get metalStorage(): Number
      {
         return StringUtil.evalFormula(Config.getBuildingMetalStorage(type), 
            {"level": level});
      };
      
      [Bindable (event="levelChange")]
      public function get energyStorage(): Number
      {
         return StringUtil.evalFormula(Config.getBuildingEnergyStorage(type), 
            {"level": level});
      };
      
      [Bindable (event="levelChange")]
      public function get zetiumStorage(): Number
      {
         return StringUtil.evalFormula(Config.getBuildingZetiumStorage(type), 
            {"level": level});
      };
      
      public function get constructablePosition(): Number
      {
         return Config.getConstructablePosition(type);
      }
      
      [Bindable (event="buildingTypeChange")]
      public function get name(): String
      {
         return (ResourceManager.getInstance().getString('Buildings', type + '.name'));
      }
      
      public static function getConstructableBuildings(): ArrayCollection
      {
         var constructable: ArrayCollection = new ArrayCollection();
         var types: Array = Config.getBuildingsTypes();
         
         for each (var buildingType: String in types)
         {
            if (Config.getBuildingNotConstructable(buildingType))
               continue;
            if (buildingIsValid(buildingType))
               constructable.addItem(buildingType);
         }
         return constructable;
      }
      
      public static function buildingIsValid(buildingType: String = null):Boolean
      {
         return Requirement.isValid(Config.getBuildingRequirements(buildingType));
      }
      
      
      /**
       * Changes building's position: <code>x</code> and <code>y</code> properties
       * are set to new values provided and <code>xEnd</code> and <code>yEnd</code>
       * properties are modified accordingly. This method allows you to pass
       * negative values. However this will result <code>positionLegal</code>
       * property change it's value to <code>false</code>.
       * 
       * @param x
       * @param y
       * 
       * @return <code>true</code> if the building was actually moved or
       * <code>false</code> otherwise.
       */      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         if (x == this.x && y == this.y)
            return false;
         var w:Number = width;
         var h:Number = height;
         suppressDimensionChangeEvent = true;
         this.x = x;
         this.y = y;
         this.xEnd = x + w - 1;
         this.yEnd = y + h - 1;
         suppressDimensionChangeEvent = false;
         dispatchDimensionChangeEvent();
         return true;
      }
      
      
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection([TileKind.WATER].concat(TileKind.RESOURCE_TILES));
      /**
       * List of tile types that this building can't be built on. Items in the collection
       * are integers from <code>TileKind</code> class. Instances of <code>Building</code>
       * class return empty collection with only four items: <code>TileKind.WATER</code>
       * and all three resource tiles.
       * 
       * @see models.tile.TileKind
       */
      protected function getRestrictedTiles() : ArrayCollection
      {
         return RESTRICTED_TILES;
      }
      
      public function getInfoData(): Object{
         return Config.getBuildingProperties(type);
      }
      
      /**
       * Lets you find out if this building can be built on particular tile type.
       * 
       * @param t One of <code>TileKind</code> constant values or <code>null</code> for regular tile.
       * 
       * @return <code>true</code> if the building can't be built on the given tile type or
       * <code>false</code> otherwise.  
       */
      public function isTileRestricted(t:*) : Boolean
      {
         return getRestrictedTiles().contains(t);
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      private function upgradePart_upgradeProgressHandler(event:UpgradeEvent) : void
      {
         dispatchHpChangeEvent();
         dispatchHpMaxChangeEvent();
      }
      
      private function upgradePart_lvlChangeHandler(event:UpgradeEvent) : void
      {
         dispatchHpMaxChangeEvent();
      }
      
      private function dispatchHpMaxChangeEvent() : void
      {
         dispatchEvent(new UpgradeEvent(UpgradeEvent.HP_MAX_CHANGE));
      }
      
      private function dispatchHpChangeEvent() : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.HP_CHANGE));
      }
      
      public function dispatchQueryChangeEvent(e: Event = null) : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.QUERY_CHANGE));
      }
      
      private function dispatchTypeChangeEvent() : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.TYPE_CHANGE));
      }
      
      public function dispatchCollapseEvent() : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.COLLAPSE));
      }
      
      public function dispatchExpandEvent() : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.EXPAND));
      }
      
      public function dispatchExpandFinishedEvent() : void
      {
         dispatchEvent(new BuildingEvent(BuildingEvent.EXPAND_FINISHED));
      }
   }
}