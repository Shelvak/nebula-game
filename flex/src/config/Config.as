package config
{
   import models.building.BuildingBonuses;
   import models.resource.ResourceType;
   import models.tile.FolliageTileKind;
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;
   
   import namespaces.client_internal;
   
   import utils.ArrayUtil;
   import utils.PropertiesTransformer;
   import utils.StringUtil;
   
   
   /**
    * Holds all game configuration data received from server. 
    */
   public class Config
   {
      // Variables in client_internal namespace allow replacing implementation of certain configuration getters.
      // This allows unit tests to be independent from server: you only have to provide implementations
      // before running unit tests. Othwerwise configuration data would have to be retrieved from server.
      // These variables should hold function with same signature as their counterparts in public namespace.
      
      
      private static var _data: Object = null;
      
      public static var assetsConfig: Object = null;
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
      
      /* ################################### */
      /* ### TECHNOLOGIES CONFIG GETTERS ### */
      /* ################################### */
      
      public static function getTechnologyProperty(type:String, prop:String) : *
      {
         return getValue
         ("technologies." + StringUtil.firstToLowerCase(type) + "." + prop);
      }
      
      public static function getTechnologyProperties(type:String): Object
      {
         return grabPropertiesFromData("^technologies\." + StringUtil.firstToLowerCase(type));
      }
      
      public static function getTechnologyMinScientists(type: String): int
      {
         return int(getTechnologyProperty(type, 'scientists.min'));
      }
      
      public static function getTechnologiesMods(): Object
      {
         var mods: Object = {};
         var props: Object = grabPropertiesFromData("^technologies", 1);
         for (var key: String in props)
         {
            var parts: Array = key.split('.');
            if (parts[1] == 'mod')
            {
               if (mods[parts[0]] == null)
                  mods[parts[0]] = {};
               mods[parts[0]][parts[2] + '.' + parts[3]] = props[key];
            }
         }
         return mods;
      }
      
      /**
       * Returns given resource component of technology cost.
       *  
       * @param type Type of the technology.
       * @param resource Type of the resource. Use constants
       * in <code>ResourceType</code> class.
       * 
       * @return Given resource component cost value of the given technology. 
       */
      public static function getTechnologyCost(type:String, resource:String) : String
      {
         return String(getTechnologyProperty(type, resource + ".cost")) == "undefined"?"0":
            String(getTechnologyProperty(type, resource + ".cost"));
      }
      
      public static function getTechnologyEnergyCost(type:String) : String
      {
         return getTechnologyCost(type, ResourceType.ENERGY);
      }
      
      public static function getTechnologyMetalCost(type:String) : String
      {
         return getTechnologyCost(type, ResourceType.METAL);
      }
      
      public static function getTechnologyZetiumCost(type:String) : String
      {
         return getTechnologyCost(type, ResourceType.ZETIUM);
      }
      
      public static function getTechnologyMaxLevel(type: String): int
      {
         return getTechnologyProperty(type, "maxLevel");
      }
      
      public static function getTechnologyUpgradeTime(type:String) : String
      {
         return getTechnologyProperty(type, "upgradeTime");
      }
      
      public static function getTechnologiesSpeedUpBoost(): Number
      {
         return Number(getTechnologyProperty('speedUp', 'time.mod'));
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
            if (parts[0] == "speedUp") {
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
      
      public static function getUnitHp(type:String) : String
      {
         return getUnitProperty(type, "hp");
      }
      
      public static function getUnitUpgradeTime(type:String) : String
      {
         return getUnitProperty(type, "upgradeTime");
      }
      
      
      client_internal static var getUnitKind:Function = function(type:String) : String
      {
         return getUnitProperty(type, "kind");
      }
      
      public static function getUnitKind(type: String): String
      {
         return client_internal::getUnitKind(type);
      }
      
      /**
       * Returns given resource component of unit cost.
       *  
       * @param type Type of the unit.
       * @param resource Type of the resource. Use constants
       * in <code>ResourceType</code> class.
       * 
       * @return Given resource component cost value of the given unit. 
       */
      public static function getUnitCost(type:String, resource:String) : String
      {
         return String(getUnitProperty(type, resource + ".cost")) == "undefined"?"0":
            String(getUnitProperty(type, resource + ".cost"));
      }
      
      public static function getUnitEnergyCost(type:String) : String
      {
         return getUnitCost(type, ResourceType.ENERGY);
      }
      
      public static function getUnitMetalCost(type:String) : String
      {
         return getUnitCost(type, ResourceType.METAL);
      }
      
      public static function getUnitZetiumCost(type:String) : String
      {
         return getUnitCost(type, ResourceType.ZETIUM);
      }
      
      public static function getUnitGuns(type: String): Object
      {
         return getUnitProperty(type, 'guns');
      }
      
      
      
      /* ################################ */
      /* ### BUILDINGS CONFIG GETTERS ### */
      /* ################################ */
      
      
      public static function getBuildingGuns(type: String): Object
      {
         return getBuildingProperty(type, 'guns');
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
      
      /**
       * Returns list of all building types
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
         return getBuildingProperty(type, 'constructable.position');
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
      
      private static function getBuildingGenerateRate(type: String, resource: String): String
      {
         return getBuildingProperty(type, resource + ".generate") == null? "0" :
            getBuildingProperty(type, resource + ".generate");
      }
      
      private static function getBuildingUseRate(type: String, resource: String): String
      {
         return getBuildingProperty(type, resource + ".use") == null? "0" :
            getBuildingProperty(type, resource + ".use");
      }
      
      private static function getBuildingStorage(type: String, resource: String): String
      {
         return getBuildingProperty(type, resource + ".store") == null? "0" :
            getBuildingProperty(type, resource + ".store");
      }
      
      public static function getBuildingMetalGenerateRate(type:String) : String
      {
         return getBuildingGenerateRate(type, "metal");
      }
      
      public static function getBuildingMetalUseRate(type:String) : String
      {
         return getBuildingUseRate(type, "metal");
      }
      
      public static function getBuildingMetalStorage(type:String) : String
      {
         return getBuildingStorage(type, "metal");
      }
      
      public static function getBuildingEnergyGenerateRate(type:String) : String
      {
         return getBuildingGenerateRate(type, "energy");
      }
      
      public static function getBuildingEnergyUseRate(type:String) : String
      {
         return getBuildingUseRate(type, "energy");
      }
      
      public static function getBuildingEnergyStorage(type:String) : String
      {
         return getBuildingStorage(type, "energy");
      }
      
      public static function getBuildingZetiumGenerateRate(type:String) : String
      {
         return getBuildingGenerateRate(type, "zetium");
      }
      
      public static function getBuildingZetiumUseRate(type:String) : String
      {
         return getBuildingUseRate(type, "zetium");
      }
      
      public static function getBuildingZetiumStorage(type:String) : String
      {
         return getBuildingStorage(type, "zetium");
      }
      
      public static function getBuildingHp(type:String) : String
      {
         return getBuildingProperty(type, "hp");
      }
      
      public static function getBuildingWidth(type:String) : int
      {
         return getBuildingProperty(type, "width");
      }
      
      public static function getBuildingHeight(type:String) : int
      {
         return getBuildingProperty(type, "height");
      }
      
      public static function getBuildingUpgradeTime(type:String) : String
      {
         return getBuildingProperty(type, "upgradeTime");
      }
      
      /**
       * Returns given resource component of building cost.
       *  
       * @param type Type of the building.
       * @param resource Type of the resource. Use constants
       * in <code>ResourceType</code> class.
       * 
       * @return Given resource component cost value of the given building. 
       */
      public static function getBuildingCost(type:String, resource:String) : String
      {
         return String(getBuildingProperty(type, resource + ".cost")) == "undefined"?"0":
            String(getBuildingProperty(type, resource + ".cost"));
      }
      
      public static function getBuildingEnergyCost(type:String) : String
      {
         return getBuildingCost(type, ResourceType.ENERGY);
      }
      
      public static function getBuildingMetalCost(type:String) : String
      {
         return getBuildingCost(type, ResourceType.METAL);
      }
      
      public static function getBuildingZetiumCost(type:String) : String
      {
         return getBuildingCost(type, ResourceType.ZETIUM);
      }
      
      public static function getBuildingRadarStrength(type: String) : String
      {
         return String(getBuildingProperty(type, 'radar.strength')) == "undefined" ? "0" :
            String(getBuildingProperty(type, 'radar.strength'));
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
      
      public static function getBattlefieldFolliageVariations() : int
      {
         return _data["ui.battlefield.folliage.blocking.variations"] as int;
      }
      
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
      
      public static function getBattlefieldFolliageAnimations(terrainType:int, variation:int) : Object
      {
         var key:String = "images.battlefield.folliages.blocking." + terrainType + "." 
            + variation + ".actions";
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
      
      public static function getDamageMultiplyers(type: String): Object
      {
         return grabPropertiesFromData("^damages\." + StringUtil.firstToLowerCase(type));
      }
   }
}