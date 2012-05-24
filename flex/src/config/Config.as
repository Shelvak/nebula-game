package config
{
   import models.building.Building;
   import models.building.BuildingBonuses;
   import models.tile.TileKind;
   import models.unit.ReachKind;

   import mx.collections.ArrayCollection;

   import namespaces.client_internal;

   import utils.ModelUtil;
   import utils.StringUtil;
   import utils.StringUtil;

   /**
    * Holds all game configuration data received from server. 
    */
   public final class Config
   {
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
         requirementsCache = {};
         
         _allUnitTypes = null;
         allUnitTypes;
         
         _allBuildingTypes = null;
         allBuildingTypes;
         
         unlockHash = getUnlockingHash();
      }

      private static var _numberOfTips:int = 0;
      client_internal static function setNumberOfTips(value: int): void {
         _numberOfTips = value;
      }
      public static function getNumberOfTips():int {
         return _numberOfTips;
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

      private static var requirementsCache: Object = {};
      
      /**
       * 
       * @param type type of the object etc.: unit, building...
       * @param name name of the type object, etc.: Seeker, ZetiumExtractor...
       * @return Object with requirements for type object
       * 
       */      
      private static function getRequirements(type: String, name: String):Object
      {
         if (requirementsCache[type + '||' + name] != null)
         {
            return requirementsCache[type + '||' + name];
         }
         var requirementStringList: Object = grabPropertiesFromData(
            "^" + type + "\." + StringUtil.firstToLowerCase(name) + "\.requirement", 3
         );
         var requirements:Object = new Object();
         
         for (var key: String in requirementStringList) {
            var parts: Array = key.split(".");
            
            var unit:String = StringUtil.underscoreToCamelCase(parts[0]);
            var unitKey:String = parts[1];
            
            if (requirements[unit] == null) {
               requirements[unit] = new Object();
            }
            
            requirements[unit][unitKey] = requirementStringList[key];
         }
         requirementsCache[type + '||' + name] = requirements;
         return requirements;
      }
      
      /* ############################ */
      /* ### OTHER CONFIG GETTERS ### */
      /* ############################ */
       
      public static function getAbsorptionDivider(): Number
      {
          return getValue('combat.absorption.divider');
      }

      public static function getCriticalMultiplier(): Number
      {
          return getValue('combat.critical.multiplier');
      }

      /* returns a formula */
      public static function getBattlegroundCreds(): String
      {
         return getValue('battleground.battle.creds');
      }

      /* returns a formula */
      public static function getCombatCreds(): String
      {
         return getValue('combat.battle.creds');
      }

      /* returns a formula */
      public static function getBattlegroundVictoryPoints(): String
      {
         return getValue('battleground.battle.victoryPoints');
      }

      /* returns a formula */
      public static function getCombatVictoryPoints(): String
      {
         return getValue('combat.battle.victoryPoints');
      }

      public static function getVPZones(): Array
      {
         return getValue("combat.battle.vpZones");
      }
      
      public static function getMaxPopulation(): int
      {
         return getValue("galaxy.player.population.max");
      }

      public static function getApocalypseSurvivalBonus(days: int): int {
         return StringUtil.evalFormula(
            getValue("galaxy.apocalypse.survivalBonus"),
            {"days": days}
         );
      }

      /* returns a formula */
      public static function getBuildingCooldownMod(type: String): String
      {
         return getBuildingProperty(type,  "mod.cooldown");
      }

      /* returns a formula */
      public static function getFee(type: String): String
      {
         return getBuildingProperty(type, "fee");
      }
      
      public static function getMarketRange(): Number
      {
         return getValue("market.avgRate.offset");
      }

      public static function getMinOfferOffset(): Number
      {
         return getValue("market.avgRate.minPrice.offset");
      }
      
      public static function getMinMarketOffer(): int
      {
         return getValue("market.offer.minAmount");
      }
      
      public static function getMaxMarketOffers(): int
      {
         return getValue("market.offers.max");
      }
      
      /**
       * Returns rounding precision mostly used by resource rate calculations
       * @return rounding precision
       */      
      public static function getRoundingPrecision(): int
      {
         return getValue("buildings.resources.roundingPrecision");
      }
      
      public static function getSpeed(): int
      {
         return getValue('speed');
      }
      
      public static function getRaidingPlanetUnits(): Object
      {
         return getValue('raiding.raiders.planet');
      }

      public static function getRaidingPlanetsMaxArg(): int
      {
         return getValue('raiding.raiders.planet.maxArg');
      }

      public static function getRaidingBattlegroundMaxArg(): int
      {
         return getValue('raiding.raiders.battleground.maxArg');
      }

      public static function getRaidingBattlegroundUnits(): Object
      {
         return getValue('raiding.raiders.battleground');
      }

      public static function getRaidingApocalypseUnits(): Object
      {
         return getValue('raiding.raiders.apocalypse');
      }

      public static function getMiniBattlegroundBoss(): Array {
         return getValue("spawn.mini_battleground.units");
      }

      public static function getBattlegroundBoss(): Array {
         return getValue("spawn.battleground.units")
      }
      
      public static function getPointsToWin(): int
      {
         return getValue('battleground.victory.condition'); 
      }
      
      
      /**
       * Returns duration of a pre-battle cooldown in seconds.
       */
      public static function getPreBattleCooldownDuration() : Number
      {
         return getValue("combat.cooldown.afterJump.duration");
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
            
            if (requirements[parts[3]] == null) 
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
      
      public static function getTechnologyName(type: String): String
      {
         return getTechnologyProperty(type, 'name');
      }

      public static function getTechnologyGroupElements(type: String): Array
      {
         var groupToStringList: Object = grabPropertiesFromData(
         "^(technologies)\..+?\.groupTo", 1);

         var groupElements:Array = [];

         for (var key: String in groupToStringList) {
            var parts: Array = key.split(".");

            var techType:String = StringUtil.firstToUpperCase(parts[0]);

            if (getTechnologyGroupTo(techType) == type)
            {
               groupElements.push(techType);
            }
         }
         return groupElements;
      }

      public static function getTechnologyGroupTo(type: String): String
      {
         var techType: String = getTechnologyProperty(type, 'groupTo');
         return techType == null ? null : StringUtil.underscoreToCamelCase(techType);
      }

      /* Returns a formula */
      public static function getTechnologyPlanetsRequired(type: String): String
      {
         return getTechnologyProperty(type, 'planets.required');
      }

      /* Returns a formula */
      public static function getTechnologyPulsarsRequired(type: String): String
      {
         return getTechnologyProperty(type, 'pulsars.required');
      }

      public static function getTechnologyGroupPosition(type: String): int
      {
         var prop: * = getTechnologyProperty(type, 'groupPosition');
         return prop != null ? prop : -1; ;
      }
      
      public static function getTechnologyWarPoints(type: String): String
      {
         return getTechnologyProperty(type, 'warPoints');
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
            
            var name: String = StringUtil.underscoreToCamelCase(parts[0]);
            
            // If there are no such technology in our data
            if (types.indexOf(name) == -1)
               types.push(name);
         }
         return types;
      }

      /* ################ */
      /* ### ALLIANCE ### */
      /* ################ */

      public static function getAllianceLeaveCooldown(): int
      {
         return getValue("alliances.leave.cooldown");
      }

      public static function getAllianceMaxPlayers(techLevel:int) : int
      {
         if (techLevel == 0) {
            return 0;
         }
         return StringUtil.evalFormula(
            getTechnologyProperty("Alliances", "maxPlayers"),
            {"level": techLevel}
         );
      }

      /**
       * @return seconds
       */
      public static function getAllianceTakeOverInactivityTime(): int {
         return getValue("alliances.takeOver.inactivityTime");
      }
      
      
      /* ############################ */
      /* ### UNITS CONFIG GETTERS ### */
      /* ############################ */


      /* For 1 dmg point to this type of unit */
      public static function getUnitVictoryPointsBonus(type: String): Number
      {
         return getUnitProperty(type, 'vpsOnDamage') != null
            ? getUnitProperty(type, 'vpsOnDamage')
            : 0;
      }

      /* Const of creds for killing one unit */
      public static function getUnitCredsBonus(type: String): int
      {
         return getUnitProperty(type, 'credsForKilling');
      }
      
      public static function getResourceVolume(type: String) : Number
      {
         return getValue('units.transportation.volume.'+type);
      }
      
      public static function getUnitPopulation(type: String): int
      {
         return getUnitProperty(type, 'population');
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
         ("units." + StringUtil.underscoreToCamelCaseFirstLower(type) + "." + prop);
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
         return grabPropertiesFromData("^units\." + StringUtil.underscoreToCamelCaseFirstLower(type));
      }
      
      public static function getUnitMaxLevel(type: String): int
      {
         return getUnitProperty(type, "maxLevel");
      }
      
      public static function getUnitDeploysTo(type: String): String
      {
         return getUnitProperty(type, "deploysTo");
      }
      
      public static function getUnitXpNeeded(type: String): String
      {
         return getUnitProperty(type, "xpNeeded");
      }
      
      public static function getUnitStorage(type: String): String
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
         return getRequirements('units', StringUtil.underscoreToCamelCaseFirstLower(type));
      }
      
      public static function getUnitHp(type:String) : int
      {
         return getUnitProperty(type, "hp");
      }
      
      public static function getUnitKind(type: String): String
      {
         return getUnitProperty(type, "kind");
      }
      
      public static function getUnitGuns(type: String): Array
      {
         return getUnitProperty(type, 'guns');
      }
      
      public static function getUnitDestructResourceGain(): int
      {
         return getValue('units.selfDestruct.resourceGain');
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
               if ((getUnitKind(StringUtil.underscoreToCamelCase(parts[0])) == reach) || (reach == ReachKind.BOTH))
               {
                  types.push(StringUtil.underscoreToCamelCase(parts[0]));
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
               types.push(StringUtil.underscoreToCamelCase(parts[0]));
         }
         return types;
      }
      
      
      /* ################ */
      /* ### MOVEMENT ### */
      /* ################ */
      
      
      /**
       * Minimum value of squad speed modifier: devide 1 from the result of this function to find out
       * maximum number of times you can decrease squad movement speed.
       */
      public static function getMinMovementSpeedModifier() : Number
      {
         return getValue("units.move.modifier.min");
      }
      
      
      /**
       * Maximum value of squad speed modifier (not necessarily 1 which means that if speed modifier is
       * greater than one squadron will actully get slowed down): devide 1 from the result of this function
       * to find out minimum number of times you can decrease squad movement speed.
       */
      public static function getMaxMovementSpeedModifier() : Number
      {
         return getValue("units.move.modifier.max");
      }
      
      
      /**
       * Returns formula to calculate creds cost.
       * formula requires params 'percentage' and 'hop_count'
       */
      public static function getMovementSpeedUpCredsCost() : String
      {
         return getValue("creds.move.speedUp");
      }
      
      /**
       * Returns max movement speed up creds cost
       */
      public static function getMovementSpeedUpMaxCredsCost() : int
      {
         return getValue("creds.move.speedUp.maxCost");
      }
      
      
      /* ################################ */
      /* ### BUILDINGS CONFIG GETTERS ### */
      /* ################################ */

      /* in seconds */
      public static function getBuildingDestructSafeguardTime(): int
      {
         return getValue('buildings.selfDestruct.creds.safeguardTime');
      }

      public static function getBuildingOverdriveOutput(): Number
      {
         return getValue('buildings.overdrive.multiplier.output');
      }
      
      public static function getBuildingOverdriveUsage(): Number
      {
         return getValue('buildings.overdrive.multiplier.energyUsage');
      }
      
      public static function getBuildingCredsBonus(type: String): int
      {
         return getBuildingProperty(type, 'creds');
      }
      
      public static function getBuildingVictoryPtsBonus(type: String): int
      {
         return getBuildingProperty(type, 'victoryPoints');
      }
      
      public static function getBuildingMoveCost() : int
      {
         return getValue("creds.building.move");
      }
      
      /* Returns a formula */
      public static function getBuildingMaxTransportableVolume(type: String): String
      {
         return getBuildingProperty(type,  "maxVolume")
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

       public static function getBuildingDestroyable(type: String): Boolean
       {
           return getBuildingProperty(type, 'destroyable') == null? true
                   : getBuildingProperty(type, 'destroyable');
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
                     types.push(StringUtil.underscoreToCamelCase(parts[0]));
                  }
               }
         }
         return types;
      }
      
      
      public static function getBuildingWithGunsTypes(): Array
      {
         var types: Array = new Array();
         var data: Object = grabPropertiesFromData("^buildings\.", 1);
         for (var key: String in data)
         {
            var parts: Array = key.split(".");
            if (parts[1] == 'hp' && Building.buildingHasGuns(
                    StringUtil.underscoreToCamelCase(parts[0])))
               types.push(StringUtil.underscoreToCamelCase(parts[0]));
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
            
            var name: String = StringUtil.underscoreToCamelCase(building.building);
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
      
      
      /* ################# */
      /* ### ALLIANCES ### */
      /* ################# */
      
      public static function getMaxAllyNameLength() : int
      {
         return getValue("alliances.validation.name.length.max");
      }
      
      public static function getMinAllyNameLength() : int
      {
         return getValue("alliances.validation.name.length.min");
      }
      
      public static function getMaxAllyDescriptionLength(): int
      {
         return getValue("alliances.validation.description.length.max");
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
      
      /**
       * @return number of solar system variations  
       */
      public static function getSolarSystemVariations() : int
      {
         return getValue("ui.solarSystem.variations");
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
               key = StringUtil.underscoreToCamelCase(key);
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
      
      private static function getCredsProperty(key: String): *
      {
         return getValue('creds.' + key);
      }
      
      public static function getAccelerateInfo(): Array
      {
         return getCredsProperty('upgradable.speedUp');
      }
      
      public static function getTechnologyUnlearnCost(): int
      {
         return getCredsProperty('technology.destroy');
      }
      
      public static function getMoveCredits(): int
      {
         return getCredsProperty('building.move');
      }
      
      public static function getDestructCredits(): int
      {
         return getCredsProperty('building.destroy');
      }
      
      public static function getEditAllianceCredits(): int
      {
         return getCredsProperty('alliance.change');
      }
      
      public static function getPlanetBoost(): Number
      {
         return getCredsProperty('planet.resources.boost');
      }
      
      public static function getPlanetBoostDuration(): Number
      {
         return getCredsProperty('planet.resources.boost.duration');
      }
      
      public static function getPlanetBoostCost(): int
      {
         return getCredsProperty('planet.resources.boost.cost');
      }
      
      public static function getVipCredsTickDuration(): int
      {
         return getCredsProperty('vip.tick.duration');
      }
      
      public static function getVipMaxLevel(): int
      {
         return (getCredsProperty('vip') as Array).length;
      }
      
      public static function getVipBonus(level: int): Array
      {
         return getCredsProperty('vip')[level - 1];
      }
   }
}