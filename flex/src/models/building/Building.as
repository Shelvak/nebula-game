package models.building
{
   // Explicitly reference all building classes here that are not referenced directly anywhere in the code.
   MetalExtractor;
   MetalExtractorT2;
   ZetiumExtractor;
   ZetiumExtractorT2;
   CollectorT3;
   
   
   import config.Config;
   
   import flash.display.BitmapData;
   
   import models.ModelsCollection;
   import models.building.events.BuildingEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.parts.BuildingUpgradable;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.parts.events.UpgradeEvent;
   import models.planet.PlanetObject;
   import models.resource.ResourceType;
   import models.tile.Tile;
   import models.tile.TileKind;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   
   import namespaces.prop_name;
   
   import spark.components.List;
   
   import utils.MathUtil;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   import utils.locale.Localizer;
   
   
   /**
    * Dispatched when <code>level</code> property has changed.
    * 
    * @eventType models.parts.events.UpgradeEvent.LVL_CHANGE
    */
   [Event(name="levelChange", type="models.parts.events.UpgradeEvent")]
   
   /**
    * Dispatched when any health points properties - and as a result <code>isDamaged</code>
    * - have changed.
    * 
    * @eventType models.building.events.BuildingEvent.HP_CHANGE
    */
   [Event (name="hpChange", type="models.building.events.BuildingEvent")]
   
   
   /**
    * Dispatched when type property has changed.
    * 
    * @eventType models.building.events.BuildingEvent.TYPE_CHANGE
    */
   [Event(name="typeChange", type="models.building.events.BuildingEvent")]
   
   
   /**
    * Dispatched when constructionQueueEntries property has changed.
    * 
    * @eventType models.building.events.BuildingEvent.QUERY_CHANGE
    */
   [Event(name="queryChange", type="models.building.events.BuildingEvent")]
   
   
   [Bindable]
   /**
    * Generic building of a game.
    */
   public class Building extends PlanetObject implements IUpgradableModel
   {
      private static function evalRateFormula(buildingType:String,
                                              resourceType:String,
                                              generationType:String,
                                              params:Object) : Number
      {
         var formula:String = Config.getBuildingProperty(buildingType, resourceType + "." + generationType);
         if (!formula)
         {
            return 0;
         }
         var roundingPrecision:uint = Config.getRoundingPrecision();
         return MathUtil.round(StringUtil.evalFormula(formula, params), roundingPrecision);
      }
      
      public static const GENERATE: String = 'generate';
      public static const USE: String = 'use';
      public static const STORE: String = 'store';
      public static const RADAR_STRENGTH: String = 'radar.strength';
      public static const FEE: String = 'fee';
      public static const HEALING_COST_MOD: String = 'healing.cost.mod';
      public static const HEALING_TIME_MOD: String = 'healing.time.mod';
      
      public static function getMarketTaxRate(marketLevel: int): Number
      {
         return StringUtil.evalFormula(Config.getMarketFee(), 
            {'level': marketLevel});
      }
      
      /**
       * Calculates and returns given resource generation rate for the given building. The value returned has
       * already been rounded and should not be modified in similar way.
       * 
       * @param buildingType type of a building
       * @param resourceType type of a resource
       * @param params custom parameters for a formula
       * 
       * @return resource generation rate per second (already rounded to correct precision)
       */
      public static function calculateResourceGenerationRate(buildingType:String,
                                                             resourceType:String,
                                                             params:Object) : Number
      {
         return evalRateFormula(buildingType, resourceType, GENERATE, params);
      }
      
      public static function getPopulation(buildingType: String, buildingLevel: int): int
      {
         return Math.round(StringUtil.evalFormula(
            Config.getBuildingProperty(buildingType, 'population'), 
            {'level': buildingLevel}));
      }
      
      [Bindable (event="typeChange")]
      public function get managable(): Boolean
      {
         return Config.getBuildingManagable(type);
      }
      
      [Bindable (event="levelChange")]
      public function get scientists(): int
      {
         return Math.round(StringUtil.evalFormula(Config.getBuildingScientists(type), 
            {'level': upgradePart.level}));
      }
      
      [Bindable (event="levelChange")]
      public function get nextScientists(): int
      {
         return Math.round(StringUtil.evalFormula(Config.getBuildingScientists(type), 
            {'level': upgradePart.level + 1}));
      }
      
      [Bindable (event="typeChange")]
      public function get unitBonus(): ArrayCollection
      {
         return Config.getBuildingUnitBonus(type);
      }
      
      /**
       * Calculates and returns given resource usage rate for the given building. The value returned has
       * already been rounded and should not be modified in similar way.
       * 
       * @param buildingType type of a building
       * @param resourceType type of a resource
       * @param params custom parameters for a formula
       * 
       * @return resource usage rate per second (already rounded to correct precision)
       */
      public static function calculateResourceUsageRate(buildingType:String,
                                                        resourceType:String,
                                                        params:Object) : Number
      {
         return evalRateFormula(buildingType, resourceType, USE, params);
      }
      
      
      /**
       * Calculates and returns given resource maximum storage capacity for the given building. The value
       * returned has already been rounded and should not be modified in similar way.
       * 
       * @param buildingType type of a building
       * @param resourceType type of a resource
       * @param params custom parameters for a formula
       * 
       * @return resource maximum storage capacity rate (already rounded to correct precision)
       */
      public static function calculateResourceMaxStorageCapacity(buildingType:String,
                                                                 resourceType:String,
                                                                 params:Object) : Number
      {
         return evalRateFormula(buildingType, resourceType, STORE, params);
      }
      
      
      /**
       * Calculates and returns strenth of the radar of the given building or <code>0</code> if that building
       * is not a radar.
       * 
       * @param buildingType type of a building
       * @param params custom parameters for a formula
       * 
       * @return strent of the radar of the given building
       */
      public static function calculateRadarStrenth(buildingType:String, params:Object) : int
      {
         var formula:String = Config.getBuildingProperty(buildingType, RADAR_STRENGTH);
         if (!formula)
         {
            return 0;
         }
         return StringUtil.evalFormula(formula, params);
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
      
      [Bindable (event="levelChange")]
      public function get leveledConstructionMod(): int
      {
         var cMod: int;
         try
         {
            cMod = Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS, type, 
               'mod.construction', {'level': level});
         }
         catch (e: ArgumentError)
         {
            cMod = 0;
         }
         return cMod;
      }
      
      [Bindable (event="levelChange")]
      public function get totalConstructorMod(): int
      {
         return Math.min(100 - Config.getMinTimePercentage(), constructorMod + leveledConstructionMod);
      }
      
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
         super();
         _upgradePart = new BuildingUpgradable(this);
         _upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROGRESS, upgradePart_upgradeProgressHandler, false, 0, true);
         _upgradePart.addEventListener(UpgradeEvent.LEVEL_CHANGE, upgradePart_lvlChangeHandler, false, 0, true);
      }
      
      
      /**
       * <p>After calling this method you won't be able to access any upgradable properties.</p>
       * 
       * @inheritDoc
       */
      public function cleanup() : void
      {
         if (_upgradePart != null)
         {
            _upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROGRESS, upgradePart_upgradeProgressHandler, false);
            _upgradePart.removeEventListener(UpgradeEvent.LEVEL_CHANGE, upgradePart_lvlChangeHandler, false);
            _upgradePart.cleanup();
            _upgradePart = null;
         }
      }
      
      
      /**
       * from which unit this building was requested to deploy
       * this property is set only before construction of this building 
       */      
      public var unitDeployed: Unit = null;
      
      public var selectedCount: int = 1;
      
      private var _constructionQueueEntries: ModelsCollection = new ModelsCollection();
      
      [Bindable (event="queryChange")]
      public function getQueueEmptySpace(): int
      {
         var count: int = 0;
         if (constructableType == null)
         {
            count--;
         }
         for each (var entry: ConstructionQueueEntry in constructionQueueEntries)
         count += entry.count;
         return Config.getBuildingMaxQueue(type) - count;
      }
      
      [Bindable (event="queryChange")]
      [Optional(elementType="models.constructionqueueentry.ConstructionQueueEntry")]
      public function set constructionQueueEntries(value: ModelsCollection): void
      {
         _constructionQueueEntries = value;
         dispatchQueryChangeEvent();
      }
      
      public function get constructionQueueEntries(): ModelsCollection
      {
         return _constructionQueueEntries;
      }
      
      [Optional]
      public var cooldownEndsAt: Date = new Date();
      
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
      
      [Bindable (event="typeChange")]
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
         return Extractor.isExtractorType(type);
      }
      
      
      [Bindable(event="typeChange")]
      public function get constructableItems() : ArrayCollection
      {
         return Config.getBuildingConstructableItems(type);
      }
      
      
      [Bindable(event="planetObjectImageChange")]
      override public function get imageData() :BitmapData
      {
         return IMG.getImage(AssetNames.getBuildingImageName(type));
      }
      
      
      [Bindable (event="typeChange")]
      public function get npc(): Boolean
      {
         return Config.getBuildingNpc(type);
      }
      
      
      prop_name static const state:String = "state";
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
      
      
      [Bindable (event="queryChange")]
      [Required]
      public function set constructableType(value: String): void
      {
         if (value != _constructableType)
         {
            _constructableType = value;
            dispatchQueryChangeEvent();
         }
      }
      
      public function get constructableType(): String
      {
         return _constructableType;
      }
      
      private var _constructableType: String = null;
      
      
      private var _hp: int = 0;
      [Required]
      [Bindable(event="hpChange")]
      public function set hp(v:int) : void
      {
         _hp = v;
         dispatchHpChangeEvent();
      }
      /**
       * @private
       */
      public function get hp() : int
      {
         return _hp;
      }
      
      
      
      [Bindable(event="hpMaxChange")]
      public function get hpMax() : int
      {
         var levelToSet: int = upgradePart.level;
         if (upgradePart.upgradeEndsAt != null)
            levelToSet++;
         
         return BuildingUpgradable.calculateHitPoints(type, levelToSet);
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
         return Localizer.string('Buildings', type + '.about');
      };
      
      [Bindable(event="hpChange")]
      /**
       * Indicates if this building is damaged (<code>hp < hpMax</code>). 
       */
      public function get isDamaged() : Boolean
      {
         return hp < hpMax;
      }
      
      
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
      [SkipProperty]
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
         return calcEffectiveResourceRate(ResourceType.METAL);
         
      };
      
      [Bindable (event="typeChange")]
      public function get maxLevel(): int
      {
         return Config.getBuildingMaxLevel(type);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextMetalRate(): Number
      {
         return calcNextResourceRate(ResourceType.METAL);
         
      };
      
      [Bindable (event="levelChange")]
      public function get energyRate(): Number
      {
         return calcEffectiveResourceRate(ResourceType.ENERGY, 1 + energyMod / 100);
         
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextEnergyRate(): Number
      {
         return calcNextResourceRate(ResourceType.ENERGY, 1 + energyMod / 100);
         
      };
      
      
      [Bindable (event="levelChange")]
      public function get zetiumRate(): Number
      {
         return calcEffectiveResourceRate(ResourceType.ZETIUM);
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextZetiumRate(): Number
      {
         return calcNextResourceRate(ResourceType.ZETIUM);
         
      };
      
      
      [Bindable (event="levelChange")]
      public function get metalStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.METAL);
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextMetalStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.METAL);
      };
      
      
      [Bindable (event="levelChange")] 
      public function get energyStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.ENERGY);
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextEnergyStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.ENERGY);
      };
      
      
      [Bindable (event="levelChange")]
      public function get zetiumStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.ZETIUM);
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextZetiumStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.ZETIUM);
      };
      
      
      [Bindable (event="levelChange")]
      public function get radarStrength() : int
      {
         return calculateRadarStrenth(type, {"level": level});
      };
      
      
      [Bindable (event="levelChange")]
      public function get nextRadarStrength() : int
      {
         return calculateRadarStrenth(type, {"level": level+1});
      };
      
      
      public function get constructablePosition() : Number
      {
         return Config.getConstructablePosition(type);
      };
      
      
      [Bindable (event="typeChange")]
      public function get name() : String
      {
         return (Localizer.string('Buildings', type + '.name'));
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
         {
            return false;
         }
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
      
      public function getInfoData(): Object
      {
         return Config.getBuildingProperties(type);
      }
      
      /**
       * Lets you find out if this building can be built on particular tile type.
       * 
       * @param t One of <code>TileKind</code> constant values or instance of <code>Tile</code>.
       * <code>null</code>s are considered as tiles of <code>TileKind.REGULAR</code> kind.
       * 
       * @return <code>true</code> if the building can't be built on the given tile type or
       * <code>false</code> otherwise.  
       */
      public function isTileRestricted(t:*) : Boolean
      {
         if (t == null)
         {
            t = TileKind.REGULAR;
         }
         if (t is Tile)
         {
            t = Tile(t).kind;
         }
         return getRestrictedTiles().contains(t);
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", type: " + type + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Calculates final resource rate (at building's current level) like this:
       * <code>generationRate ~~ generationRateMultiplier - usageRate</code>.
       */
      private function calcEffectiveResourceRate(resourceType:String,
                                                 generationRateMultiplier:Number = 1) : Number
      {
         var params:Object = {"level": level};
         return calculateResourceGenerationRate(type, resourceType, params) * generationRateMultiplier -
            calculateResourceUsageRate(type, resourceType, params);
      }
      
      /**
       * Calculates final resource rate (at building's current level) like this:
       * <code>generationRate ~~ generationRateMultiplier - usageRate</code>.
       */
      private function calcNextResourceRate(resourceType:String,
                                                 generationRateMultiplier:Number = 1) : Number
      {
         var params:Object = {"level": level + 1};
         return calculateResourceGenerationRate(type, resourceType, params) * generationRateMultiplier -
            calculateResourceUsageRate(type, resourceType, params);
      }
      
      /**
       * Calculates maximum storage capacity of the building at its current level.
       */
      private function calcMaxStorageCapacity(resourceType:String) : Number
      {
         return calculateResourceMaxStorageCapacity(type, resourceType, {"level": level});
      }
      
      /**
       * Calculates maximum storage capacity of the building at its current level.
       */
      private function calcNextStorageCapacity(resourceType:String) : Number
      {
         return calculateResourceMaxStorageCapacity(type, resourceType, {"level": level+1});
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
         if (hasEventListener(UpgradeEvent.HP_MAX_CHANGE))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.HP_MAX_CHANGE));
         }
      }
      
      private function dispatchHpChangeEvent() : void
      {
         if (hasEventListener(BuildingEvent.HP_CHANGE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.HP_CHANGE));
         }
      }
      
      public function dispatchQueryChangeEvent(e: Event = null) : void
      {
         if (hasEventListener(BuildingEvent.QUERY_CHANGE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.QUERY_CHANGE));
         }
      }
      
      private function dispatchTypeChangeEvent() : void
      {
         if (hasEventListener(BuildingEvent.TYPE_CHANGE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.TYPE_CHANGE));
         }
      }
      
      public function dispatchCollapseEvent(e: FlexEvent = null) : void
      {
         if (e != null)
         {
            List(e.currentTarget).removeEventListener(FlexEvent.UPDATE_COMPLETE, dispatchCollapseEvent);
         }
         if (hasEventListener(BuildingEvent.COLLAPSE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.COLLAPSE));
         }
      }
      
      public function dispatchExpandEvent(e: FlexEvent = null) : void
      {
         if (e != null)
         {
            List(e.currentTarget).removeEventListener(FlexEvent.UPDATE_COMPLETE, dispatchExpandEvent);
         }
         if (hasEventListener(BuildingEvent.EXPAND))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.EXPAND));
         }
      }
      
      public function dispatchExpandFinishedEvent() : void
      {
         if (hasEventListener(BuildingEvent.EXPAND_FINISHED))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.EXPAND_FINISHED));
         }
      }
   }
}