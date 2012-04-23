package models.building
{
   import config.Config;

   import controllers.objects.ObjectClass;

   import flash.display.BitmapData;
   import flash.events.Event;

   import models.ModelsCollection;
   import models.building.events.BuildingEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.parts.BuildingUpgradable;
   import models.parts.IUpgradableModel;
   import models.parts.Requirement;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.parts.events.UpgradeEvent;
   import models.planet.MPlanetObject;
   import models.resource.ResourceType;
   import models.tile.TileKind;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;

   import namespaces.prop_name;

   import spark.components.List;

   import utils.MathUtil;
   import utils.ModelUtil;
   import utils.Objects;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   import utils.locale.Localizer;


   // Explicitly reference all building classes here that are not referenced directly anywhere in the code.
   MetalExtractor;
   MetalExtractorT2;
   ZetiumExtractor;
   ZetiumExtractorT2;
   CollectorT3;


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
   public class Building extends MPlanetObject implements IUpgradableModel
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

      public var metaLevel: int = -1;
      public function get hasMetaLevel(): Boolean {
         return metaLevel > -1;
      }
      
      public static function getFee(type: String, level: int): Number
      {
         return StringUtil.evalFormula(Config.getFee(type),
            {'level': level});
      }

      public static function getBuildingCooldownMod(type: String,  level: int): Number
      {
         return StringUtil.evalFormula(Config.getBuildingCooldownMod(
            type), {'level': level});
      }

      public static function getResourceTransporterCooldown(level: int,
         volume: int): int
      {
         return Math.ceil(getBuildingCooldownMod(BuildingType.RESOURCE_TRANSPORTER, level) * volume);
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
      
      private static function openableType(type: String): Boolean
      {
         return [BuildingType.HEALING_CENTER,
            BuildingType.RESEARCH_CENTER,
            BuildingType.DEFENSIVE_PORTAL,
            BuildingType.RESOURCE_TRANSPORTER,
            BuildingType.MARKET
         ].indexOf(type) != -1;
      }

      /**
       * Sets the size of for the given building. Loads size values from config.
       * 
       * @return the building given
       */
      public static function setSize(building:Building): Building {
         Objects.paramNotNull("building", building);
         building.setSize(
            Config.getBuildingWidth(building.type),
            Config.getBuildingHeight(building.type)
         );
         return building;
      }
      
      [Bindable (event="typeChange")]
      public function get openable(): Boolean
      {
         return openableType(type) || isConstructor(ObjectClass.UNIT);
      }
      
      [Bindable (event="typeChange")]
      public function get managable(): Boolean
      {
         return Config.getBuildingManagable(type);
      }

       [Bindable (event="typeChange")]
       public function get destroyable(): Boolean
       {
           return Config.getBuildingDestroyable(type);
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
       * Calculates and returns strength of the radar of the given building or <code>0</code> if that building
       * is not a radar.
       * 
       * @param buildingType type of a building
       * @param params custom parameters for a formula
       * 
       * @return strength of the radar of the given building
       */
      public static function calculateRadarStrength(buildingType:String, params:Object) : int
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
         return Upgradable.evalUpgradableFormula(
            UpgradableType.BUILDINGS,
            type,
            'mod.construction',
            {'level': level}
         );
      }
      
      [Bindable (event="levelChange")]
      public function get totalConstructorMod(): int
      {
         return Math.min(100 - Config.getMinTimePercentage(), constructorMod + leveledConstructionMod);
      }

      [Bindable (event="levelChange")]
      public function get maxTransportableStorage(): int
      {
         return Math.round(StringUtil.evalFormula(
            Config.getBuildingMaxTransportableVolume(type), {'level': level}));
      }

      [Bindable (event="levelChange")]
      public function get fee(): Number
      {
         return getFee(type,  level);
      }
      
      /**
       * Mandatory gap between buildings.
       */
      public static const GAP_BETWEEN:int = 1;
      
      //states constants
      public static const INACTIVE: int = 0;
      public static const ACTIVE: int = 1;
      public static const WORKING: int = 2;
      public static const REPAIRING: int = 3;
      
      
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
      public function getQueueTotalPopulation(): int
      {
         var totalCost: int = 0;
         for each (var entry: ConstructionQueueEntry in constructionQueueEntries)
         {
            if (entry.prepaid)
            {
               totalCost += Config.getUnitPopulation(ModelUtil.getModelSubclass(
                       entry.constructableType)) * entry.count;
            }
         }
         return totalCost;
      }

      [Bindable (event="queryChange")]
      public function getQueueTotalResourceValue(resType: String): int
      {
         function calcCost(qEntry: ConstructionQueueEntry): int
         {
            return Upgradable.calculateCost(qEntry.isUnit
                    ? UpgradableType.UNITS : UpgradableType.BUILDINGS,
                    ModelUtil.getModelSubclass(qEntry.constructableType),
                    resType, {'level': 1}) * qEntry.count;
         }
         var totalCost: int = 0;
         for each (var entry: ConstructionQueueEntry in constructionQueueEntries)
         {
            if (entry.prepaid)
            {
               totalCost += calcCost(entry);
            }
         }
         return totalCost;
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

      public function get damagePercentage(): Number
      {
         return (hpMax - hp)/hpMax;
      }

      public function get alivePercentage(): Number
      {
         return hp/hpMax;
      }

      // TODO: make this MTimeEventFixedMoment
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

      public static function buildingHasGuns(type: String): Boolean
      {
         var guns: Array = Config.getBuildingGuns(type);
         return ((guns != null) && (guns.length > 0));
      }

      public function get hasGuns(): Boolean
      {
         return buildingHasGuns(type);
      }
      
      
      [Bindable(event="modelIdChange")]
      public function get isGhost() : Boolean
      {
         return id == 0;
      }

      public var prepaid: Boolean;
      
      
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
       * 3 - repairing
       */
      public var state: int = 0;
      
      private var _overdriven: Boolean = false;
      
      public function set overdriven(value: Boolean): void
      {
         _overdriven = value;
         dispatchOverdrivenChangeEvent();
      }
      
      [Optional]
      [Bindable (event="overdrivenChange")]
      public function get overdriven(): Boolean
      {
         return _overdriven;
      }
      
      /**
       * Id of the constructable item which this building is currently constructing
       */      
      [Optional]
      public var constructableId: int = 0;
      
      /**
       * Id of the constructor which is currently constructing this building
       */      
      public var constructorId: int = 0;
      
      
      [Bindable (event="queryChange")]
      [Optional]
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
       * @see models.planet.MPlanetObject#isBlocking
       */
      override public function get isBlocking() : Boolean
      {
         return true;
      }
      
      
      public function get description(): String
      {
         return Localizer.string('Buildings', type + '.about');
      }
      
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
      
      [Optional]
      public var buildIn2ndFlank: Boolean = false;

      [Optional]
      public var buildHidden: Boolean = false;
      
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
      
      public function get usesResource(): Boolean
      {
         return metalRate < 0 || energyRate < 0 || zetiumRate < 0;
      }
      
      [Bindable (event="levelChange")]
      public function get metalRate(): Number
      {
         return calcEffectiveResourceRate(ResourceType.METAL);
         
      }
      
      [Bindable (event="typeChange")]
      public function get maxLevel(): int
      {
         return Config.getBuildingMaxLevel(type);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextMetalRate(): Number
      {
         return calcNextResourceRate(ResourceType.METAL);
         
      }
      
      [Bindable (event="levelChange")]
      public function get energyRate(): Number
      {
         return calcEffectiveResourceRate(ResourceType.ENERGY, 1 + energyMod / 100);
         
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextEnergyRate(): Number
      {
         return calcNextResourceRate(ResourceType.ENERGY, 1 + energyMod / 100);
         
      }
      
      
      [Bindable (event="levelChange")]
      public function get zetiumRate(): Number
      {
         return calcEffectiveResourceRate(ResourceType.ZETIUM);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextZetiumRate(): Number
      {
         return calcNextResourceRate(ResourceType.ZETIUM);
         
      }
      
      
      [Bindable (event="levelChange")]
      public function get metalStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.METAL);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextMetalStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.METAL);
      }
      
      
      [Bindable (event="levelChange")] 
      public function get energyStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.ENERGY);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextEnergyStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.ENERGY);
      }
      
      
      [Bindable (event="levelChange")]
      public function get zetiumStorage() : Number
      {
         return calcMaxStorageCapacity(ResourceType.ZETIUM);
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextZetiumStorage() : Number
      {
         return calcNextStorageCapacity(ResourceType.ZETIUM);
      }
      
      
      [Bindable (event="levelChange")]
      public function get radarStrength() : int
      {
         return calculateRadarStrength(type, {"level": level});
      }
      
      
      [Bindable (event="levelChange")]
      public function get nextRadarStrength() : int
      {
         return calculateRadarStrength(type, {"level": level+1});
      }
      
      
      public function get constructablePosition() : Number
      {
         return Config.getConstructablePosition(type);
      }
      
      
      [Bindable (event="typeChange")]
      public function get name() : String
      {
         return (Localizer.string('Buildings', type + '.name'));
      }
      
      
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection(TileKind.RESOURCE_TILES);
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
       * @param t One of <code>TileKind</code> constant values
       * @param borderTile is the given tile a border tile of the building?
       * 
       * @return <code>true</code> if the building can't be built on the given tile type or
       * <code>false</code> otherwise.  
       */
      public function isTileRestricted(t:int, borderTile:Boolean = false) : Boolean
      {
         return getRestrictedTiles().contains(t);
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className +
                ", id: " + id +
                ", level: " + level +
                ", type: " + type + 
                ", x: " + x +
                ", xEnd: " + xEnd +
                ", y: " + y +
                ", yEnd: " + yEnd + "]";
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
      
      private function dispatchOverdrivenChangeEvent(): void
      {
         if (hasEventListener(BuildingEvent.OVERDRIVEN_CHANGE))
         {
            dispatchEvent(new BuildingEvent(BuildingEvent.OVERDRIVEN_CHANGE));
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