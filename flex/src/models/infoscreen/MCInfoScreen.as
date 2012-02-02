package models.infoscreen
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.infoscreen.UnitBuildingInfoEntry;
   import components.infoscreen.table.IRInfoTableRowEmpty;
   import components.infoscreen.table.IRInfoTableRowFull;
   import components.infoscreen.table.IRInfoTableRowHalf;
   import components.infoscreen.table.InfoTableLevel;
   
   import config.Config;
   
   import controllers.objects.ObjectClass;
   import controllers.ui.NavigationController;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.healing.HealPrice;
   import models.infoscreen.events.InfoScreenEvent;
   import models.parts.BuildingUpgradable;
   import models.parts.TechnologyUpgradable;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.parts.events.UpgradeEvent;
   import models.resource.ResourceType;
   import models.technology.Technology;
   import models.technology.events.TechnologyEvent;
   import models.unit.ReachKind;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   
   import utils.DateUtil;
   import utils.MathUtil;
   import utils.ModelUtil;
   import utils.NumberUtil;
   import utils.SingletonFactory;
   import utils.StringUtil;
   import utils.StringUtil;
   import utils.locale.Localizer;
   
   public class MCInfoScreen extends EventDispatcher
   {
      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      public function MCInfoScreen(target: IEventDispatcher = null)
      {
         super(target);
         EventBroker.subscribe(GlobalEvent.APP_RESET, reset);
         ML.technologies.addEventListener(TechnologyEvent.TECHNOLOGY_CHANGED, dispatchTechsChangeEvent);
      }
      
      public static function getInstance(): MCInfoScreen
      {
         return SingletonFactory.getSingletonInstance(MCInfoScreen);
      }
      
      private static const MAX_WEAK_LENGTH: int = 1000;

      private static const XP_NEEDED: String = 'xpNeeded';
      
      //properties that dont need to be displayed in difference column of datagrid
      private static const diffIgnorableProperties: Array =
         ['upgradeTime', 'metal.cost', 'energy.cost', 'zetium.cost', 'deploysTo',
            'volume', 'width', 'height', 'move.solarSystem.hopTime',
            'move.galaxy.hopTime'];
      
      //properties that dont need to be displayed in data grid
      private static const ignorableProperties: Array = 
         ['metal.starting', 'energy.starting', 'zetium.starting', 'maxLevel', 'coords', 'constructor.items',
            'kind', 'constructable.position', 'constructable', 'npc', 'requirement', 'ui', 'actions', 'box', 'dead.passable', 'frameWidth',
            'gunPoints', 'targetPoint', 'xpModifier', 'appliesTo', 'armor', 'deploysTo', 'upgradeTime', 'metal.cost', 'energy.cost', 'zetium.cost',
            'unitBonus', 'destroyable', 'cooldown', 'managable', 'name'];
      
      [Bindable]
      public var model: InfoObject;
      
      [Bindable]
      public var isNpc: Boolean = false;
      
      [Bindable]
      public var deploysTo: String;
      
      public function set infoModel(value: *): void
      {
         guns.removeAll();
         if (oldOriginModel != null)
         {
            if ((oldOriginModel is Building || oldOriginModel is Technology) &&
               oldOriginModel.upgradePart != null)
            {
               oldOriginModel.upgradePart.removeEventListener(
                  UpgradeEvent.LEVEL_CHANGE, 
                  dealWithPropertiesChange, false
               );
            }
         }
         model = new InfoObject(value);  
         oldOriginModel = value;
         if (value != null)
         {
            if (value is Building || value is Technology)
            {
               value.upgradePart.addEventListener(
                  UpgradeEvent.LEVEL_CHANGE, 
                  dealWithPropertiesChange, false, 0, true
               );
            }
            selectedLevel = model.usefulLevel;
            sliderMoved = false;
            refreshDataForTable();
         }
         isNpc = model.infoData != null?model.infoData.npc:false;
         deploysTo = model.infoData != null?model.infoData.deploysTo:null;
         dispatchModelChangedEvent();
      }
      
      [Bindable]
      public var metalCostString: String;
      
      [Bindable]
      public var energyCostString: String;
      
      [Bindable]
      public var zetiumCostString: String;
      
      [Bindable]
      public var timeCostString: String;
      
      [Bindable]
      public var cMetalCostString: String;
      
      [Bindable]
      public var cEnergyCostString: String;
      
      [Bindable]
      public var cZetiumCostString: String;
      
      [Bindable]
      public var cTimeCostString: String;
      
      [Bindable]
      public var tMetalCostString: String;
      
      [Bindable]
      public var tEnergyCostString: String;
      
      [Bindable]
      public var tZetiumCostString: String;
      
      [Bindable]
      public var tTimeCostString: String;
      
      [Bindable]
      public var dMetalCostString: String;
      
      [Bindable]
      public var dEnergyCostString: String;
      
      [Bindable]
      public var dZetiumCostString: String;
      
      [Bindable]
      public var dTimeCostString: String;
      
      public var sliderMoved: Boolean = false;
      
      [Bindable]
      public var selectedLevel: int;
      
      //old model to keep deal with it's event listeners
      private var oldOriginModel: *; 
      
      [Bindable]
      public var guns: ArrayCollection = new ArrayCollection();
      
      [Bindable]
      public var dataForTable: ArrayCollection = new ArrayCollection();
      
      [Bindable]
      public var fullCostData: ArrayCollection = new ArrayCollection();
      
      private function dealWithPropertiesChange(e: Event): void
      {
         model = new InfoObject(oldOriginModel); 
         selectedLevel = model.usefulLevel;
         dispatchLevelChangeEvent();
         refreshDataForTable();
      }
      
      public function getTableItemRenderer(currentLvl: int, maxLvl: int,
                                           selectedLvl: int): IFactory
      {
         switch (getTableLevel(currentLvl, maxLvl, selectedLvl))
         {
            case InfoTableLevel.FULL:
               return new ClassFactory(IRInfoTableRowFull);
               break;
            case InfoTableLevel.HALF:
               return new ClassFactory(IRInfoTableRowHalf);
               break;
            case InfoTableLevel.EMPTY:
               return new ClassFactory(IRInfoTableRowEmpty);
               break;
         }
         return null;
      }
      
      public function getTableLevel(currentLvl: int, maxLvl: int,
                                    selectedLvl: int): int
      {
         if ((currentLvl != maxLvl) && selectedLvl != currentLvl &&
            !(currentLvl == 0 && selectedLvl == 1))
         {
            return InfoTableLevel.FULL;
         }
         else if (currentLvl != maxLvl)
         {
            return InfoTableLevel.HALF;
         }
         else
         {
            return InfoTableLevel.EMPTY;
         }
      }
      
      public function refreshDataForTable(): void
      {  
         if (model == null)
         {
            return;
         }
         dataForTable.removeAll();
         fullCostData.removeAll();
         for (var element: String in model.infoData)
         {
            var hourly: Boolean = false;
            if ((ignorableProperties.indexOf(element) == -1)
                    && (ignorableProperties.indexOf(element.split('.')[0]) == -1))
            {
               var currentValue: Number;
               var newValue: Number;
               
               if (element == 'guns')
               {
                  if (!sliderMoved)
                  {
                     createGuns(model.infoData[element]);
                  }
               }
               else
               {
                  var useRounding: Boolean = false;
                  if ((element.indexOf(ResourceType.METAL) != -1 ||
                     element.indexOf(ResourceType.ENERGY) != -1 ||
                     element.indexOf(ResourceType.ZETIUM) != -1) && (model.objectType == ObjectClass.BUILDING))
                  {
                     var parts: Array = element.split('.');
                     if (parts[1] == Building.GENERATE)
                     {
                        currentValue = Building.calculateResourceGenerationRate(model.type, parts[0],
                           {'level': model.usefulLevel});
                        newValue = Building.calculateResourceGenerationRate(model.type, parts[0],
                           {'level': selectedLevel});
                        hourly = true;
                     }
                     else if (parts[1] == Building.USE)
                     {
                        currentValue = Building.calculateResourceUsageRate(model.type, parts[0],
                           {'level': model.usefulLevel});
                        newValue = Building.calculateResourceUsageRate(model.type, parts[0],
                           {'level': selectedLevel});
                        hourly = true;
                     }
                     else if (parts[1] == Building.STORE)
                     {
                        currentValue = Building.calculateResourceMaxStorageCapacity(model.type, parts[0],
                           {'level': model.usefulLevel});
                        newValue = Building.calculateResourceMaxStorageCapacity(model.type, parts[0],
                           {'level': selectedLevel});
                     }
                     useRounding = true;
                  }
                  else if (element == HealPrice.HEALING_COST_MOD
                          || element == HealPrice.HEALING_TIME_MOD)
                  {
                     if (model.objectType == ObjectClass.BUILDING)
                     {
                        currentValue = MathUtil.round(Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS,
                           model.type, element, {'level': model.usefulLevel}),
                           Config.getRoundingPrecision());
                        newValue = MathUtil.round(Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS,
                           model.type, element, {'level': selectedLevel}),
                           Config.getRoundingPrecision());
                     }
                     else
                     {
                        currentValue = MathUtil.round(Upgradable.evalUpgradableFormula(UpgradableType.TECHNOLOGIES,
                           model.type, element, {'level': model.usefulLevel}),
                           Config.getRoundingPrecision());
                        newValue = MathUtil.round(Upgradable.evalUpgradableFormula(UpgradableType.TECHNOLOGIES,
                           model.type, element, {'level': selectedLevel}),
                           Config.getRoundingPrecision());
                     }
                     useRounding = true;
                  }
                  else if (element == Technology.WAR_POINTS)
                  {
                     currentValue = Technology.getWarPoints(model.type, model.usefulLevel);
                     newValue = Technology.getWarPoints(model.type, selectedLevel);
                  }
                  else if (element == Building.FEE)
                  {
                     currentValue = Math.round(Building.getFee(model.type, model.usefulLevel) * 100);
                     newValue = Math.round(Building.getFee(model.type, selectedLevel) * 100);
                  }
                  else if (element == Building.RADAR_STRENGTH)
                  {
                     currentValue = Building.calculateRadarStrenth(model.type,
                        {'level': model.usefulLevel});
                     newValue = Building.calculateRadarStrenth(model.type,
                        {'level': selectedLevel});
                     useRounding = true;
                  }
                  else if (element == TechnologyUpgradable.SCIENTISTS_MIN)
                  {
                     currentValue = TechnologyUpgradable.getMinScientists(model.type, model.usefulLevel);
                     newValue = TechnologyUpgradable.getMinScientists(model.type, selectedLevel);
                  }
                  else if (element.indexOf(TechnologyUpgradable.MOD) == 0)
                  {
                     if (model.objectType == ObjectClass.BUILDING)
                     {
                        currentValue = BuildingUpgradable.getConstructionMod(model.type, model.usefulLevel);
                        newValue = BuildingUpgradable.getConstructionMod(model.type, selectedLevel);
                     }
                     else
                     {
                        currentValue = TechnologyUpgradable.getMod(model.type, model.usefulLevel,
                           element.slice(4));
                        newValue = TechnologyUpgradable.getMod(model.type, selectedLevel,
                           element.slice(4));
                     }
                  }
                  else if (element == XP_NEEDED)
                  {
                     currentValue = StringUtil.evalFormula(model.infoData[element],
                        {"level": model.usefulLevel + 1});
                     newValue = StringUtil.evalFormula(model.infoData[element],
                        {"level": selectedLevel + 1});
                  }
                  else
                  {
                     currentValue = StringUtil.evalFormula(model.infoData[element], 
                        {"level": model.usefulLevel});
                     newValue = StringUtil.evalFormula(model.infoData[element], 
                        {"level": selectedLevel});
                  }
                  
                  var label: String;
                  switch (model.objectType)
                  {
                     case ObjectClass.BUILDING:
                        label = Localizer.string('Buildings', 'property.' + element);
                        break;
                     case ObjectClass.TECHNOLOGY:
                        label = Localizer.string('Technologies', 'property.' + element);
                        break;
                     case ObjectClass.UNIT:
                        label = Localizer.string('Units', 'property.' + element);
                        break;
                  }
                  if (label == null) {
                     label = "!!! " + element;
                  }
                  
                  var newValueString: String;
                  var currentValueString: String;
                  var diffString: String;
                  
                  if (hourly)
                  {
                     newValue = newValue * 3600;
                     currentValue = currentValue * 3600;
                     newValueString = NumberUtil.toShortString(newValue)+ ' / ' +
                        Localizer.string('General', 'hour.short');
                     currentValueString = NumberUtil.toShortString(currentValue)+ ' / ' +
                        Localizer.string('General', 'hour.short');
                     diffString = NumberUtil.toShortString(newValue - currentValue)+ ' / ' +
                        Localizer.string('General', 'hour.short');
                  }
                  else
                  {
                     newValueString = newValue.toString();
                     currentValueString = currentValue.toString();
                     
                     if (useRounding)
                     {
                        diffString = MathUtil.round(newValue - currentValue, 
                           Config.getRoundingPrecision()).toString();
                     }
                     else
                     {
                        diffString = (newValue - currentValue).toString();
                     }
                  }
                  
                  if (element == Unit.JUMP_IN_GALAXY
                          || element == Unit.JUMP_IN_SS)
                  {
                     currentValueString = Unit.getJumpTime(model.infoData[element],
                             model.type,
                             model.usefulLevel);
                     newValueString = Unit.getJumpTime(model.infoData[element],
                             model.type,
                             model.usefulLevel);
                  }
                  
                  if (element.indexOf(TechnologyUpgradable.MOD) == 0
                     || element == Building.FEE)
                  {
                     newValueString += '%';
                     currentValueString += '%';
                     diffString += '%';
                  }
                  
                  if (diffIgnorableProperties.indexOf(element) != -1)
                  {
                     diffString = '-';
                  }
                  dataForTable.addItem(
                     new MInfoRow(label, currentValueString, newValueString, diffString));
               }
            }
         }
         if (!sliderMoved)
         {
            refreshBottomUnits(model.infoData['appliesTo']);
         }
         sliderMoved = false;
         dataForTable.sort = new Sort();
         dataForTable.sort.fields = [new SortField('property', true, false)];
         dataForTable.refresh();
         recalculateFullCosts();
         dispatchRefreshSelectedGunEvent();
         if (selectedGun != null)
         {
            bestAgainst = selectedGun.getBestTargets(selectedLevel, getTechDamageMod(model.type));
            bestAgainst.sort = new Sort();
            bestAgainst.sort.fields = [new SortField('type')];
            bestAgainst.refresh();
         }
      }
      
      private function reset(e: GlobalEvent): void
      {
         infoModel = null;
      }
      
      private function recalculateFullCosts(): void
      {
         var fullMetalCost: int = 0;
         var fullEnergyCost: int = 0;
         var fullZetiumCost: int = 0;
         var fullTimeCost: int = 0;
         
         function getCost(key: String, level: int): Number
         {
            return Upgradable.calculateCost((model.objectType == ObjectClass.BUILDING?
               UpgradableType.BUILDINGS:(model.objectType == ObjectClass.UNIT?
                  UpgradableType.UNITS:UpgradableType.TECHNOLOGIES)), model.type, key, 
               {'level': level});
         }
         
         function getTechUpgradeTime(level: int): int
         {
            return TechnologyUpgradable.calculateTechUpgradeTime(model.type, level,
               TechnologyUpgradable.getMinScientists(model.type, level), 
               TechnologyUpgradable.getMinScientists(model.type, level), false);
         }
         
         if (model.currentLevel + 1 <= selectedLevel)
         {
            for (var i: int = model.currentLevel + 1; i <= selectedLevel; i++)
            {
               fullMetalCost += getCost(ResourceType.METAL, i);
               fullEnergyCost += getCost(ResourceType.ENERGY, i);
               fullZetiumCost += getCost(ResourceType.ZETIUM, i);
               if (model.objectType == ObjectClass.TECHNOLOGY)
                  fullTimeCost += getTechUpgradeTime(i);
               else
                  fullTimeCost += Upgradable.calculateUpgradeTime((
                     model.objectType == ObjectClass.BUILDING?
                     UpgradableType.BUILDINGS:UpgradableType.UNITS), model.type, 
                     {"level": i});
            }
         }
         metalCostString = fullMetalCost.toString();
         energyCostString = fullEnergyCost.toString();
         zetiumCostString = fullZetiumCost.toString();
         timeCostString = DateUtil.secondsToHumanString(fullTimeCost); 
         
         cMetalCostString = getCost(ResourceType.METAL, model.usefulLevel).toString();
         cEnergyCostString = getCost(ResourceType.ENERGY, model.usefulLevel).toString();
         cZetiumCostString = getCost(ResourceType.ZETIUM, model.usefulLevel).toString();
         tMetalCostString = getCost(ResourceType.METAL, selectedLevel).toString();
         tEnergyCostString = getCost(ResourceType.ENERGY, selectedLevel).toString();
         tZetiumCostString = getCost(ResourceType.ZETIUM, selectedLevel).toString();
         dMetalCostString = (Number(tMetalCostString) - Number(cMetalCostString)).toString();
         dEnergyCostString = (Number(tEnergyCostString) - Number(cEnergyCostString)).toString();
         dZetiumCostString = (Number(tZetiumCostString) - Number(cZetiumCostString)).toString();
         
         if (model.objectType == ObjectClass.TECHNOLOGY)
         {
            cTimeCostString = getTechUpgradeTime(model.usefulLevel).toString();
            tTimeCostString = getTechUpgradeTime(selectedLevel).toString();
         }
         else
         {
            cTimeCostString = Upgradable.calculateUpgradeTime((model.objectType == ObjectClass.BUILDING?
               UpgradableType.BUILDINGS:UpgradableType.UNITS), model.type, 
               {"level": model.usefulLevel}).toString();
            tTimeCostString = Upgradable.calculateUpgradeTime((model.objectType == ObjectClass.BUILDING?
               UpgradableType.BUILDINGS:UpgradableType.UNITS), model.type, 
               {"level": selectedLevel}).toString();
         }
         dTimeCostString = DateUtil.secondsToHumanString(Number(tTimeCostString) - Number(cTimeCostString));
         cTimeCostString = DateUtil.secondsToHumanString(int(cTimeCostString));
         tTimeCostString = DateUtil.secondsToHumanString(int(tTimeCostString));
      }
      
      private function createGuns(_guns: Array): void
      {
         guns.removeAll();
         var i: int = -1;
         for each (var gun: Object in _guns)
         {
            i++;
            var newGun: Gun;
            if (model.objectType == ObjectClass.BUILDING)
            {
               newGun = new Gun(Config.getBuildingGunType(model.type, i), gun.dpt, 
                  gun.period, gun.damage, gun.reach);
            }
            if (model.objectType == ObjectClass.UNIT)
            {
               newGun = new Gun(Config.getUnitGunType(model.type, i), gun.dpt, 
                  gun.period, gun.damage, gun.reach);
            }
            var grouped: Boolean = false;
            for each (var oldGun: Gun in guns)
            {
               if (oldGun.hashKey() == newGun.hashKey())
               {
                  oldGun.count++;
                  grouped = true;
               }
            }
            if (!grouped)
            {
               guns.addItem(newGun);
            }
         }
         dispatchGunsCreatedEvent();
      }
      
      [Bindable (event="technologyChanged")]
      public function getTechArmorMod(applies: String): Number
      {
         return Math.round(ML.technologies.getTechnologiesPropertyMod('armor', 
            model.objectType + '/' + StringUtil.camelCaseToUnderscore(applies)));
      }
      
      [Bindable (event="technologyChanged")]
      public function getTechDamageMod(applies: String): Number
      {
         return Math.round(ML.technologies.getTechnologiesPropertyMod('damage', 
            model.objectType + '/' + StringUtil.camelCaseToUnderscore(applies)));
      }
      
      public function gunsList_changeHandler(gun: Gun):void
      {
         if (selectedGun != gun)
         {
            selectedGun = gun;
            if (selectedGun != null)
            {
               bestAgainst = selectedGun.getBestTargets(selectedLevel, getTechDamageMod(model.type));
               bestAgainst.sort = new Sort();
               bestAgainst.sort.fields = [new SortField('type')];
               bestAgainst.refresh();
            }
         }
      }
      
      
      
      [Bindable]
      public var bestAgainst: ArrayCollection;
      
      [Bindable]
      public var selectedGun: Gun = null;
      
      [Bindable]
      public var weakAgainst: ArrayCollection;
      
      private function get kind(): String
      {
         if (model.objectType == ObjectClass.UNIT)
         {
            return Config.getUnitKind(model.type);
         }
         else
         {
            return ReachKind.GROUND;
         }
      }
      
      private function getObjectTitle(type: String): String
      {
         var modelClass:String = ModelUtil.getModelClass(type, true);
         var modelSubclass:String = ModelUtil.getModelSubclass(type);
         return Localizer.string(modelClass + 's', modelSubclass + '.name');
      }
      
      protected function refreshBottomUnits(appliesTo: Array): void
      {
         if ((model.objectType == ObjectClass.BUILDING && Config.getBuildingGuns(model.type).length > 0)
            || (model.objectType == ObjectClass.UNIT && Config.getUnitGuns(model.type).length > 0))
         {
            var coefObjects: ArrayCollection = new ArrayCollection();
            var buildingTypes: Array = Config.getBuildingWithGunsTypes();
            function addCoefObject(type: String, guns: Array): void
            {
               var coef: Number = 0;
               for each (var gun: Object in guns)
               {
                  if ((gun.reach == ReachKind.BOTH) || (gun.reach == kind))
                  {
                     coef += StringUtil.evalFormula(gun.dpt, {'level': 1}) * Gun.getDamageCoefToArmor(gun.damage, model.armorType);
                  }
               }
               if (coef > 0)
               {
                  coefObjects.addItem({'type': type, 'coef': coef});
               }
            }
            for each (var building: String in buildingTypes)
            {
               var guns: Array = Config.getBuildingGuns(building);
               if (!(guns.length == 0))
               {
                  addCoefObject('Building::'+building, guns);
               }
            }
            var unitTypes: Array = Config.getAllUnitsTypes();
            for each (var unit: String in unitTypes)
            {
               guns = Config.getUnitGuns(unit);
               if (!(guns.length == 0))
               {
                  addCoefObject('Unit::'+unit, guns);
               }
            }
            coefObjects.sort = new Sort();
            coefObjects.sort.fields = [new SortField('coef',false,true,true)];
            coefObjects.refresh();
            weakAgainst = new ArrayCollection();
            for (var i: int = 0; i < Math.min(MAX_WEAK_LENGTH, coefObjects.length); i++)
            {
               weakAgainst.addItem(new UnitBuildingInfoEntry(
                  coefObjects.getItemAt(i).type,
                  getObjectTitle(coefObjects.getItemAt(i).type),
                  coefObjects.getItemAt(i).coef));
            }
         }
         else if(model.objectType == ObjectClass.TECHNOLOGY
            && appliesTo != null
            && appliesTo.length > 0)
         {
            weakAgainst = new ArrayCollection();
            for each (var objectEntry: String in appliesTo)
            {
               var parts: Array = objectEntry.split('/');
               var objectType: String = parts[0];
               var objectSubtype: String = StringUtil.underscoreToCamelCase(parts[1]);
               var objectSType: String = ModelUtil.getModelType(objectType,  objectSubtype);
               weakAgainst.addItem(new UnitBuildingInfoEntry(
                  objectSType, getObjectTitle(objectSType)));
            }
         }
         else
         {
            weakAgainst = new ArrayCollection();
         }
      }
      
      public function close_clickHandler(event:MouseEvent):void
      {
         NavigationController.getInstance().showPreviousScreen();
      }
      
      /* ################### */
      /* ##### HELPERS ##### */
      /* ################### */
      
      public function dispatchModelChangedEvent(): void
      {
         if (hasEventListener(InfoScreenEvent.MODEL_CHANGE))
         {
            dispatchEvent(new InfoScreenEvent(InfoScreenEvent.MODEL_CHANGE));
         }
      }
      
      public function dispatchGunsCreatedEvent(): void
      {
         if (hasEventListener(InfoScreenEvent.GUNS_CREATED))
         {
            dispatchEvent(new InfoScreenEvent(InfoScreenEvent.GUNS_CREATED));
         }
      }
      
      public function dispatchRefreshSelectedGunEvent(): void
      {
         if (hasEventListener(InfoScreenEvent.REFRESH_SELECTED_GUN))
         {
            dispatchEvent(new InfoScreenEvent(InfoScreenEvent.REFRESH_SELECTED_GUN));
         }
      }
      
      public function dispatchLevelChangeEvent(): void
      {
         if (hasEventListener(InfoScreenEvent.MODEL_LEVEL_CHANGE))
         {
            dispatchEvent(new InfoScreenEvent(InfoScreenEvent.MODEL_LEVEL_CHANGE));
         }
      }
      
      public function dispatchTechsChangeEvent(e: TechnologyEvent): void
      {
         if (hasEventListener(TechnologyEvent.TECHNOLOGY_CHANGED))
         {
            dispatchEvent(new TechnologyEvent(TechnologyEvent.TECHNOLOGY_CHANGED));
         }
      }
   }
}