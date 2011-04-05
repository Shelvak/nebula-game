package config
{
   import controllers.objects.ObjectClass;
   
   import models.building.BuildingBonuses;
   import models.parts.UpgradableType;
   import models.tile.TileKind;
   import models.unit.ReachKind;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   import namespaces.client_internal;
   
   import utils.ModelUtil;
   import utils.StringUtil;
   
   
   /**
    * Holds all game configuration data received from server. 
    */
   public final class Config
   {
      // Variables in client_internal namespace allow replacing implementation of certain configuration getters.
      // This allows unit tests to be independent from server: you only have to provide implementations
      // before running unit tests. Othwerwise configuration data would have to be retrieved from server.
      // These variables should hold function with same signature as their counterparts in public namespace.
      
      
      private static var _data: Object = null;
      
      public static var assetsConfig: Object = null;
      
      public static var unlockHash: Object = null;
      /**
       * Sets configuration of the game.
       * 
       * @param data configuration data (not null).
       */
      public static function setConfig(data:Object) : void
      {
         _data = data;
         
         _allUnitTypes = null;
         allUnitTypes;
         
         _allBuildingTypes = null;
         allBuildingTypes;
         
         unlockHash = getUnlockingHash();
      }
      
      
      /**
       * Returns value of configuration item of a given key.
       *   
       * @param key A key for a configuration item.
       * 
       * @return Value of configuration item of a given key or null, if the given key
       * can't be found. 
       */
      public static function getValue(key:String) : *
      {
         return _data[key];
      }
      
      /**
       * Returns value of asset configuration item of a given key.
       *   
       * @param key A key for an asset configuration item.
       * 
       * @return Value of asset configuration item of a given key or null, if the given key
       * can't be found. 
       */
      public static function getAssetValue(key:String) : *
      {
         return assetsConfig["assets." + key];
      }
      
      /* ################################ */
      /* ###    TILE  MOD  GETTER     ### */
      /* ################################ */
      
      public static function getTileMod(type:int) : BuildingBonuses
      {
         var typeName: String;
         var bonusObj: BuildingBonuses = new BuildingBonuses();
         switch (type){
            case TileKind.JUNKYARD:
               typeName = "junkyard";
               break;
            case TileKind.NOXRIUM:
               typeName = "noxrium";
               break;
            case TileKind.SAND:
               typeName = "sand";
               break;
            case TileKind.TITAN:
               typeName = "titan";
               break;
            default: 
               return new BuildingBonuses();
               break;
         }
         bonusObj.armor = getValue
            ("tiles." + typeName + ".mod.armor") == null? 0 :
            getValue("tiles." + typeName + ".mod.armor");
         bonusObj.energyOutput = getValue
            ("tiles." + typeName + ".mod.energy") == null? 0 :
            getValue("tiles." + typeName + ".mod.energy");
         bonusObj.constructionTime = getValue
            ("tiles." + typeName + ".mod.construction") == null? 0 :
            getValue("tiles." + typeName + ".mod.construction");
         return bonusObj;
      }
      
      /**
       * @param skipParts How many parts of config key to cut. I.e. 2 would leave 'baz.buz' from 'foo.bar.baz.buz'
       */
      private static function grabPropertiesFromData(matching: String, skipParts:int=2): Object
      {
         var properties:Object = getMatching(
            new RegExp(matching)
         );
         
         var data:Object = {};
         for (var key:String in properties) {
            var shortKey:String = key.split(".").slice(skipParts).join(".");
            data[shortKey] = properties[key];
         }
         return data;
      }
      
      private static function getGunType(objectType: String, type: String, id: int): String
      {
         return getAssetValue('images.battlefield.'+objectType+'.'+StringUtil.firstToLowerCase(type)+'.guns')[id];
      }
      
      
      public static function getMatching(re:RegExp): Object
      {
         var data:Object = {};
         
         for (var key:String in _data) {
            if (key.match(re)) {
               data[key] = _data[key];
            }
         }
         
         return data;
      }
      
      /**
       * 
       * @param type type of the object etc.: unit, building...
       * @param name name of the type object, etc.: Seeker, ZetiumExtractor...
       * @return Object with requirements for type object
       * 
       */      
      private static function getRequirements(type: String, name: String):Object
      {
         var requirementStringList: Object = grabPropertiesFromData(
            "^" + type + "\." + StringUtil.firstToLowerCase(name) + "\.requirement", 3
         );
         
         var requirements:Object = new Object();
         
         for (var key: String in requirementStringList) {
            var parts: Array = key.split(".");
            
            var unit:String = StringUtil.firstToUpperCase(parts[0]);
            var unitKey:String = parts[1];
            
            if (requirements[unit] == null) {
               requirements[unit] = new Object();
            }
            
            requirements[unit][unitKey] = requirementStringList[key];
         }
         
         return requirements;
      }
      
      /* ############################ */
      /* ### OTHER CONFIG GETTERS ### */
      /* ############################ */
      
      /**
       * Returns rounding precision mostly used by resource rate calculations
       * @return rounding precision
       */      
      public static function getRoundingPrecision(): int
      {
         return Config.getValue("buildings.resources.roundingPrecision");
      }
      
      public static function getSpeed(): int
      {
         return getValue('speed');
      }
      
      public static function getRaidingInfo(): Array
      {
         return getValue('raiding.raiders');
      }
      
      public static function getRaidingPlanetLimit(): int
      {
         return getValue('raiding.planet.threshold');
      }
      
      public static function getPointsToWin(): int
      {
         return getValue('battleground.victory.condition'); 
      }
      
      /* ################################### */
      /* ### TECHNOLOGIES CONFIG GETTERS ### */
      /* ################################### */
      
      private static function getUnlockingHash(): Object
      {
         var requirementStringList: Object = grabPropertiesFromData(
            "^(buildings|units)\..+?\.requirement", 0);
         
         var requirements:Object = new Object();
         
         for (var key: String in requirementStringList) {
            var parts: Array = key.split(".");
            
            var upgradableType:String = StringUtil.firstToUpperCase(parts[0]);
            var type:String = parts[1];
            
            if (requirements[StringUtil.firstToUpperCase(parts[3])] == null) 
            {
               requirements[StringUtil.firstToUpperCase(parts[3])] = ModelUtil.getModelType(String(parts[0]).slice(0, String(parts[0]).length - 1), 
                  parts[1]);
            }
            else
            {
               if (getConstructablePosition(parts[1]) < getConstructablePosition(ModelUtil.getModelSubclass(
                  requirements[StringUtil.firstToUpperCase(parts[3])])))
               {
                  requirements[StringUtil.firstToUpperCase(parts[3])] = ModelUtil.getModelType(String(parts[0]).slice(0, String(parts[0]).length - 1), 
                     parts[1]);
               }
            }
         }
         return requirements;
      }
      
      public static function getTechnologyProperty(type:String, prop:String) : *
      {
         return getValue("technologies." + StringUtil.firstToLowerCase(type) + "." + prop);
      }
      
      public static function getTechnologyProperties(type:String): Object
      {
         return grabPropertiesFromData("^technologies\." + StringUtil.firstToLowerCase(type));
      }
      
      public static function getTechnologiesMods(applies: String = null): Object
      {
         var mods: Object = {};
         var props: Object = grabPropertiesFromData("^technologies", 1);
         for (var key: String in props)
         {
            var parts: Array = key.split('.');
            if (parts[1] == 'mod')
            {
               if (applies == null)
               {
                  if (mods[parts[0]] == null)
                     mods[parts[0]] = {};
                  mods[parts[0]][parts[2] + '.' + parts[3]] = props[key];
               }
               else
               {
                  var techApplies: ArrayCollection = new ArrayCollection(getTechnologyProperty(parts[0], 'appliesTo') as Array);
                  if (techApplies.getItemIndex(applies) != -1)
                  {
                     if (mods[parts[0]] == null)
                        mods[parts[0]] = {};
                     mods[parts[0]][parts[2]] = props[key];
                  }
               }
            }
         }
         return mods;
      }
      
      public static function getTechnologyMaxLevel(type: String): int
      {
         return getTechnologyProperty(type, "maxLevel");
      }
      
      public static function getTechnologiesSpeedUpBoost(): Number
      {
         return Number(getTechnologyProperty('speedUp', 'time.mod'));
      }
      
      public static function getAdditionalScientists(): Number
      {
         return getValue('technologies.scientists.additional');
      }
      
      public static function getMaxTimeReduction(): Number
      {
         return getValue('technologies.scientists.additional.maxReduction');
      }
      
      public static function getTechnologiesSpeedUpCost(): Number
      {
         return Number(getTechnologyProperty('speedUp', 'resources.mod'));
      }
      
      public static function getTechnologyCoords(type: String):Object
      {
         return getTechnologyProperty(type, "coords");
      }
      
      public static function getTechnologyRequirements(type: String):Object
      {
         return getRequirements('technologies', type);
      }
      
      public static function getTechnologiesTypes(): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^technologies\.", 1);
         for (var key: String in data) {
            var parts:Array = key.split(".");
            
            // Skip speedUp because it's a special key
            if (parts[0] == "speedUp" || parts[0] == "scientists") {
               continue;
            }
            
            var name: String = StringUtil.firstToUpperCase(parts[0]);
            
            // If there are no such technology in our data
            if (types.indexOf(name) == -1)
               types.push(name);
         }
         return types;
      }
      
      
      /* ############################ */
      /* ### UNITS CONFIG GETTERS ### */
      /* ############################ */
      
      
      public static function getResourceVolume(type: String) : Number
      {
         return getValue('units.transportation.volume.'+type);
      }
      
      /**
       * Returns property of the unit of a given type.
       * 
       * @param type Type of the unit.
       * @param prop Name of the property.
       * 
       * @return Value of the given property of given unit type.
       */
      public static function getUnitProperty(type:String, prop:String) : *
      {
         return getValue
         ("units." + StringUtil.firstToLowerCase(type) + "." + prop);
      }
      
      public static function getUnitArmorType(type: String): String
      {
         return getUnitProperty(type, 'armor');
      }
      
      public static function getUnitGunType(type: String, id: int): String
      {
         return getGunType('units', type, id);
      }
      
      public static function getUnitProperties(type:String): Object
      {
         return grabPropertiesFromData("^units\." + StringUtil.firstToLowerCase(type));
      }
      
      public static function getUnitMaxLevel(type: String): int
      {
         return getUnitProperty(type, "maxLevel");
      }
      
      public static function getUnitDeploysTo(type: String): String
      {
         return getUnitProperty(type, "deploysTo");
      }
      
      public static function getUnitStorage(type: String): int
      {
         return getUnitProperty(type, "storage");
      }
      
      public static function getUnitVolume(type: String): int
      {
         return getUnitProperty(type, "volume");
      }
      
      
      
      
      /**
       * Returns requirements for the unit
       * @param type Type of the unit
       * 
       * @return object with requirements 
       * return object key - type of technology,
       * key.level - level of techniology,
       * 
       */
      public static function getUnitRequirements(type: String):Object
      {
         return getRequirements('units', type);
      }
      
      public static function getUnitHp(type:String) : int
      {
         return getUnitProperty(type, "hp");
      }
      
      
      client_internal static var getUnitKind:Function = function(type:String) : String
      {
         return getUnitProperty(type, "kind");
      }
      
      public static function getUnitKind(type: String): String
      {
         return client_internal::getUnitKind(type);
      }
      
      public static function getUnitGuns(type: String): Array
      {
         return getUnitProperty(type, 'guns');
      }
      
      public static function getUnitsWithArmor(type: String, reach: String): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^units\.", 1);
         for (var key: String in data)
         {
            var parts: Array = key.split(".");
            if (parts[1] == 'armor' && data[key] == type)
            {
               if ((getUnitKind(StringUtil.firstToUpperCase(parts[0])) == reach) || (reach == ReachKind.BOTH))
               {
                  types.push(StringUtil.firstToUpperCase(parts[0]));
               }
            }
         }
         return types;
      }
      
      public static function getAllUnitsTypes(): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^units\.", 1);
         for (var key: String in data)
         {
            var parts: Array = key.split(".");
            if (parts[1] == 'hp')
               types.push(StringUtil.firstToUpperCase(parts[0]));
         }
         return types;
      }
      
      
      /* ################################ */
      /* ### BUILDINGS CONFIG GETTERS ### */
      /* ################################ */
      
      
      public static function getBuildingMoveCost() : int
      {
         return getValue("creds.building.move");
      }
      
      public static function getBuildingSelfDestructCooldown(): int
      {
         return getValue('buildings.selfDestruct.cooldown');
      }
      
      public static function getBuildingManagable(type: String): Boolean
      {
         return getBuildingProperty(type, 'managable') == null? true
            : getBuildingProperty(type, 'managable');
      }
      
      public static function getBuildingDestructResourceGain(): int
      {
         return getValue('buildings.selfDestruct.resourceGain');
      }
      
      public static function getBuildingGuns(type: String): Array
      {
         var guns: Array = getBuildingProperty(type, 'guns');
         return guns == null? [] : guns;
      }
      
      public static function getBuildingGunType(type: String, id: int): String
      {
         return getGunType('buildings', type, id);
      }
      
      public static function getMinTimePercentage(): Number
      {
         return Number(getValue('buildings.constructor.minTimePercentage'));
      }
      
      public static function getBuildingConstructableItems(type:String) : ArrayCollection
      {
         return new ArrayCollection(getBuildingProperty(type, "constructor.items"));
      }
      
      /**
       * Returns constructor types to build constructableType as array,
       * named as building facilities in building sidebar and facilities in unitScreen
       */
      public static function getConstructors(constructableType: String): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^buildings\.", 1);
         for (var key: String in data)
         {
            var parts: Array = key.split(".");
            if (parts.length > 2)
               if ((parts[1] == 'constructor') && (parts[2] == 'items'))
               {
                  if ((data[key][0] as String).split('/')[0] == constructableType)
                  {
                     types.push(StringUtil.firstToUpperCase(parts[0]));
                  }
               }
         }
         return types;
      }
      
      
      public static function getAllBuildingsTypes(): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^buildings\.", 1);
         for (var key: String in data)
         {
            var parts: Array = key.split(".");
            if (parts[1] == 'hp')
               types.push(StringUtil.firstToUpperCase(parts[0]));
         }
         return types;
      }
      
      /**
       * Returns list of all constructable building types
       */
      public static function getBuildingsTypes(): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^buildings\.", 1);
         var resultData: Array = new Array();
         for (var key: String in data)
         {
            var parts:Array = key.split(".");
            if (parts[1] == 'constructable')
               resultData.push({'position': data[key], 'building': parts[0]});
            resultData.sortOn('position', Array.NUMERIC);
         }
         
         for each (var building: Object in resultData) {
            
            var name: String = StringUtil.firstToUpperCase(building.building);
            types.push(name);
         }
         return types;
      }
      
      public static function getConstructablePosition(type: String): Number
      {
         return getBuildingProperty(type, 'constructable.position') == null?0:
            getBuildingProperty(type, 'constructable.position');
      }
      
      /**
       * 
       * @param type
       * @return max queue length of building type
       * 
       */      
      public static function getBuildingMaxQueue(type: String): int
      {
         return String(getBuildingProperty(type, 'queue.max')) == "undefined"? 0 :
            int(getBuildingProperty(type, 'queue.max'));
      }
      
      public static function getBuildingNpc(type: String): Boolean
      {
         return getBuildingProperty(type, 'npc');
      }
      
      /**
       * Returns requirements for the building
       * @param type Type of the building
       * 
       * @return object with requirements 
       * return object key - type of technology,
       * key.level - level of techniology,
       * 
       */
      public static function getBuildingRequirements(type: String):Object
      {
         return getRequirements('buildings', type);
      }
      
      /**
       * Returns property of the building of a given type.
       * 
       * @param type Type of the building.
       * @param prop Name of the property.
       * 
       * @return Value of the given property of given building type.
       */
      public static function getBuildingProperty(type:String, prop:String) : *
      {
         return getValue("buildings." + StringUtil.firstToLowerCase(type) + "." + prop);
      }
      
      public static function getBuildingMaxLevel(type: String): int
      {
         return getBuildingProperty(type, "maxLevel");
      }
      
      /**
       * Returns true if building is never available to construct
       */
      public static function getBuildingNotConstructable(type: String): Boolean
      {
         return getBuildingProperty(type, 'constructable.position') == null;
      }
      
      public static function getBuildingProperties(type:String): Object
      {
         return grabPropertiesFromData("^buildings\." + StringUtil.firstToLowerCase(type));
      }
      
      public static function getBuildingWidth(type:String) : int
      {
         return getBuildingProperty(type, "width");
      }
      
      public static function getBuildingHeight(type:String) : int
      {
         return getBuildingProperty(type, "height");
      }
      
      public static function getBuildingScientists(type: String) : String
      {
         return getBuildingProperty(type, "scientists");
      }
      
      public static function getBuildingUnitBonus(type: String) : ArrayCollection
      {
         var data: Array = getBuildingProperty(type, 'unitBonus');
         var tempResult: Array = [];
         if (!data || data.length == 0)
         {
            return null;
         }
         for (var i: int = 0; i < data.length; i++)
         {
            tempResult[i] = new UnitBuildingEntry(ModelUtil.getModelType(
               ObjectClass.UNIT, data[i][0]), data[i][1]);
         }
         return new ArrayCollection(tempResult);
      }
      
      
      /* ############### */
      /* ### PLANETS ### */
      /* ############### */
      
      public static function getMaxPlanetNameLength() : int
      {
         return getValue("planet.validation.name.length.max");
      }
      
      public static function getMinPlanetNameLength() : int
      {
         return getValue("planet.validation.name.length.min");
      }
      
      
      /* ##################### */
      /* ### SOLAR SYSTEMS ### */
      /* ##################### */
      
      
      client_internal static var getSolarSystemVariations:Function = function() : int
      {
         return getValue("ui.solarSystem.variations");
      };
      
      /**
       * @return number of solar system variations  
       */
      public static function getSolarSystemVariations() : int
      {
         return client_internal::getSolarSystemVariations();
      }
      
      
      /* ############## */
      /* ### CLOUDS ### */
      /* ############## */
      
      
      /**
       * @return number of cloud variations available.
       */
      public static function getCloudsVariations() : int
      {
         return getValue("ui.planet.clouds.variations");
      }
      
      
      /* ################ */
      /* ### FOLLIAGE ### */
      /* ################ */
      
      public static function getNonBlockingFolliageVariations() : int
      {
         return _data["ui.planet.folliage.variations"] as int;
      }
      
      /**
       * Returns animation information for given non-blocking folliage.
       * 
       * @param terrainType type of terrain
       * @param variation variation of a folliage
       * 
       * @return hash of animations for given non-blocking folliage or <code>null</code> if it does not
       * have any.
       */
      public static function getNonBlockingFolliageAnimations(terrainType:int, variation:int) : Object
      {
         var key:String = "images.folliage." + terrainType + ".nonblocking." + variation + ".actions";
         if (getAssetValue(key) == undefined)
         {
            return null;
         }
         else
         {
            return getAssetValue(key);
         }
      }
      
      
      /* ################################ */
      /* ### UNITS AND BUILDINDS LIST ### */
      /* ################################ */
      
      
      private static var _allBuildingTypes:ArrayCollection = null;
      /**
       * List of all building types (cached).
       */
      public static function get allBuildingTypes() : ArrayCollection
      {
         if (_allBuildingTypes == null)
         {
            _allBuildingTypes = getConstructableTypes("buildings");
         }
         return _allBuildingTypes;
      }
      
      
      private static var _allUnitTypes:ArrayCollection = null;
      /**
       * List of all unit types (cached).
       */ 
      public static function get allUnitTypes() : ArrayCollection
      {
         if (_allUnitTypes == null)
         {
            _allUnitTypes = getConstructableTypes("units");
         }
         return _allUnitTypes;
      }
      
      
      /**
       * Builds a list of construtable types of the given namespace.
       * 
       * @param namespace namespace of construtables (like)
       * @return 
       * 
       */
      private static function getConstructableTypes(namespace:String) : ArrayCollection
      {
         var list:ArrayCollection = new ArrayCollection();
         var namespacePattern:String = namespace + ".";
         for (var key:String in _data)
         {
            if (key.indexOf(namespacePattern) == 0)
            {
               key = key.replace(namespacePattern, "");
               key = key.replace(/\.(.)+/i, "");
               key = StringUtil.firstToUpperCase(key);
               if (!list.contains(key))
               {
                  list.addItem(key);
               }
            }
         }
         return list;
      }
      
      public static function getDamageMultipliers(type: String): Object
      {
         return grabPropertiesFromData("^damages\." + StringUtil.firstToLowerCase(type));
      }
      
      
      /* ############################## */
      /* ### CREDITS CONFIG GETTERS ### */
      /* ############################## */
      
      public static function getAccelerateInfo(): Array
      {
         return getValue('creds.upgradable.speedUp');
      }
      
      public static function getMoveCredits(): int
      {
         return getValue('creds.building.move');
      }
      
      public static function getDestructCredits(): int
      {
         return getValue('creds.building.destroy');
      }
   }
}