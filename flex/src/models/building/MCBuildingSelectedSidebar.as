package models.building
{
   import com.developmentarc.core.utils.EventBroker;

   import components.credits.AccelerateSelector;

   import components.credits.ConfirmCredsLabel;

   import components.popups.ActionConfirmationPopUp;
   import components.popups.WaitingCredsPopUp;

   import config.Config;

   import controllers.notifications.EventsController;

   import models.notification.MPermanentEvent;

   import controllers.buildings.BuildingsCommand;
   import controllers.constructionqueues.ConstructionQueuesCommand;
   import controllers.navigation.MCSidebar;
   import controllers.objects.ObjectClass;
   import controllers.ui.NavigationController;

   import flash.events.Event;

   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;

   import globalevents.GBuildingEvent;

   import globalevents.GPlanetEvent;

   import globalevents.GResourcesEvent;

   import globalevents.GlobalEvent;

   import models.ModelLocator;
   import models.Owner;
   import models.building.events.BuildingEvent;
   import models.building.events.BuildingSidebarEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.healing.HealPrice;
   import models.parts.Upgradable;
   import models.parts.events.UpgradeEvent;
   import models.resource.Resource;
   import models.resource.ResourcesAmount;
   import models.solarsystem.MSSObject;

   import mx.collections.ArrayCollection;
   import mx.events.DragEvent;
   import mx.managers.DragManager;

   import spark.components.Button;

   import spark.components.Label;

   import spark.components.List;
   import utils.TextFlowUtil;

   import utils.DateUtil;
   import utils.ModelUtil;

   import utils.SingletonFactory;
   import utils.UrlNavigate;
   import utils.locale.Localizer;

   public class MCBuildingSelectedSidebar extends EventDispatcher
   {
      public function MCBuildingSelectedSidebar ()
      {
         super();
         EventBroker.subscribe(GResourcesEvent.RESOURCES_CHANGE,
                 refreshPriceOrientatedProperties);
         EventBroker.subscribe(GPlanetEvent.BUILDINGS_CHANGE,
                 refreshConstructor);
      }

      public static function getInstance(): MCBuildingSelectedSidebar
      {
         return SingletonFactory.getSingletonInstance(MCBuildingSelectedSidebar);
      }
      
      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      private function get NC(): NavigationController
      {
         return NavigationController.getInstance();
      }

      //Upgrade costs
      [Bindable]
      public var metalCost: Number;

      [Bindable]
      public var energyCost: Number;

      [Bindable]
      public var zetiumCost: Number;

      [Bindable]
      public var timeCost: String;

      //Repair costs
      [Bindable]
      public var metalRepairCost: Number;

      [Bindable]
      public var energyRepairCost: Number;

      [Bindable]
      public var zetiumRepairCost: Number;

      [Bindable]
      public var timeRepairCost: String;

      [Bindable]
      public var canRepairBuilding: Boolean;
      //=======

      //Mass repair costs
      [Bindable]
      public var metalMassRepairCost: Number;

      [Bindable]
      public var energyMassRepairCost: Number;

      [Bindable]
      public var zetiumMassRepairCost: Number;

      [Bindable]
      public var timeMassRepairCost: String;

      [Bindable]
      public var canMassRepairBuilding: Boolean;
      //=======

      /**
       * how many seconds are left to fulfill resources needs for building
       **/
      [Bindable]
      public var resLeft: int = 0;
      [Bindable]
      public var repairResLeft: int = 0;
      [Bindable]
      public var massRepairResLeft: int = 0;

      [Bindable]
      public var resLeftString: String = '';
      [Bindable]
      public var repairResLeftString: String = '';
      [Bindable]
      public var massRepairResLeftString: String = '';

      [Bindable]
      public var enoughStorage: Boolean = true;
      [Bindable]
      public var enoughRepairStorage: Boolean = true;
      [Bindable]
      public var enoughMassRepairStorage: Boolean = true;
      [Bindable]
      public var missingStorageString: String = '';
      [Bindable]
      public var missingRepairStorageString: String = '';
      [Bindable]
      public var missingMassRepairStorageString: String = '';

      [Bindable]
      public var canBeUpgraded: Boolean = false;

      [Bindable]
      public var canDestroyBuilding: Boolean = false;

      private var totalCooldown: int = 0;

      [Bindable]
      public var totalDestructTimeLbl: String = '';
      [Bindable]
      public var destructRemainingTime: String = '';

      private function calculateResLeft(): void
      {
         var planet:MSSObject = ML.latestPlanet.ssObject;
         missingStorageString = Resource.getMissingStoragesString(planet,
            metalCost, energyCost, zetiumCost);
         enoughStorage = (missingStorageString == ''?true:false);
         resLeft = Resource.getTimeToReachResources
            (planet.metal, planet.energy, planet.zetium,
               metalCost, energyCost, zetiumCost);
         resLeftString = getStringFromSeconds(resLeft);
      }

      private function refreshUpgradeState(e: Event = null): void
      {
         if (_selectedBuilding != null && _selectedBuilding.upgradePart != null
                 && ML.latestPlanet != null)
         {
            var planet:MSSObject = ML.latestPlanet.ssObject;
            canBeUpgraded =
                    _selectedBuilding.upgradePart.enoughResourcesForNextLevel(
                            planet);
            calculateResLeft();
            if (canBeUpgraded)
            {
               resLeft = 0;
               resLeftString = getStringFromSeconds(resLeft);
            }
         }
      }

      private function refreshPriceOrientatedProperties(e: Event = null): void
      {
         if (_selectedBuilding != null && !_selectedBuilding.npc)
         {
            recalculateCosts();
            refreshUpgradeState();
            recalculateHealingCosts();
         }
      }

      private function recalculateCosts(): void
      {
         if (_selectedBuilding == null || _selectedBuilding.upgradePart == null)
            return;
         var resources:ResourcesAmount =
                 _selectedBuilding.upgradePart.resourcesNeededForNextLevel();
         metalCost = resources.metal;
         energyCost = resources.energy;
         zetiumCost = resources.zetium;
         timeCost = DateUtil.secondsToHumanString(
                 _selectedBuilding.upgradePart.timeNeededForNextLevel(), 3);
      }

      private function recalculateHealingCosts(): void
      {
         if (_selectedBuilding == null || _selectedBuilding.upgradePart == null)
            return;
         var resources:HealPrice = HealPrice.calculateRepairPrice(
                 _selectedBuilding);
         metalRepairCost = resources.metal;
         energyRepairCost = resources.energy;
         zetiumRepairCost = resources.zetium;
         timeRepairCost = DateUtil.secondsToHumanString(resources.cooldown, 3);

         resources = HealPrice.calculateMassRepairPrice(
                 ML.latestPlanet);
         metalMassRepairCost = resources.metal;
         energyMassRepairCost = resources.energy;
         zetiumMassRepairCost = resources.zetium;
         timeMassRepairCost = DateUtil.secondsToHumanString(resources.cooldown, 3);
      }
      
      [Bindable]
      /**
       * List of buildings player is alowed to construct.
       * 
       * @default null 
       */      
      public var constructable:ArrayCollection = null;
      
      public function openBuilding(building: Building): void
      {
         if (ML.latestPlanet.ssObject.ownerIsAlly
            && building.npc)
         {
            if (ML.latestPlanet.getAggressiveGroundUnits().length != 0)
            {
               NC.showUnits(ML.latestPlanet.getAggressiveGroundUnits(),
                  ML.latestPlanet.toLocation(), building);
            }
         }
         if (building.upgradePart.upgradeEndsAt != null 
            || ML.latestPlanet.ssObject.owner != Owner.PLAYER
            || building.state == Building.REPAIRING)
         {
            return;
         }
         switch (building.type)
         {
            case BuildingType.RESEARCH_CENTER:
               NC.showTechnologies();
               break;
            case BuildingType.RESOURCE_TRANSPORTER:
               NC.showResourceTransporter(building);
               break;
            case BuildingType.MARKET:
               NC.showMarket(building);
               break;
            case BuildingType.DEFENSIVE_PORTAL:
               if (building.state == Building.ACTIVE)
               {
                  NC.showDefensivePortal(ML.latestPlanet.id);
               }
               break;
            case BuildingType.HEALING_CENTER:
               NC.showHealing(building, ML.latestPlanet.getActiveHealableUnits());
               break;
            default:
               if (building.npc)
               {            
                  if (ML.latestPlanet.getAggressiveGroundUnits().length != 0)
                  {
                     NC.showUnits(ML.latestPlanet.getAggressiveGroundUnits(),
                        ML.latestPlanet.toLocation(), building);
                  }
               }
               else if (building.isConstructor(ObjectClass.UNIT))
               {
                  NC.showFacilities(building.id);
                  return;
               }
               else if (building.state != Building.WORKING && building.usesResource)
               {
                  if (!building.pending)
                  {
                     if (building.state == Building.ACTIVE)
                     {
                        new BuildingsCommand(BuildingsCommand.DEACTIVATE, 
                           building).dispatch ();
                     }
                     else if (building.state == Building.INACTIVE)
                     {
                        new BuildingsCommand(BuildingsCommand.ACTIVATE, 
                           building).dispatch ();
                     }
                  }
               }
               break;
         }
      }
      
      private var _selectedBuilding: Building;

      [Bindable (event="selectedBuildingChange")]
      public function get selectedBuilding(): Building
      {
         return _selectedBuilding; 
      }

      [Bindable]
      public var constructor: Building = null;

      private var eventPopUpId: int;
      
      public function set selectedBuilding(value: Building): void
      {
         if (_selectedBuilding != value)
         {
            constructable = null;
            if (_selectedBuilding != null)
            {
               _selectedBuilding.removeEventListener(
                  UpgradeEvent.LEVEL_CHANGE,
                  refreshPriceOrientatedProperties
               );
               if (_selectedBuilding.type != BuildingType.MOTHERSHIP &&
                  !_selectedBuilding.npc)
               {
                  GlobalEvent.unsubscribe_TIMED_UPDATE(global_timedUpdateHandler);
               }
               if (_selectedBuilding.type == BuildingType.NPC_HALL)
               {
                  EventBroker.unsubscribe(GlobalEvent.TIMED_UPDATE, refreshBonusTime);
               }
               if (_selectedBuilding.isGhost)
               {
                  for each (var queueEntry: ConstructionQueueEntry in constructor.constructionQueueEntries)
                  {
                     queueEntry.selected = false;
                  }
               }
               if (constructor != null)
               {
                  constructor.removeEventListener(BuildingEvent.QUERY_CHANGE, cancelDrag);
               }
               if (_selectedBuilding is Npc)
               {
                  Npc(_selectedBuilding).unitsCached = null;
               }
            }
            _selectedBuilding = value;
            dispatchSelectedBuildingChangeEvent();
            if (_selectedBuilding != null)
            {
               if ((ML.latestPlanet.ssObject.ownerIsPlayer
                  || ML.latestPlanet.ssObject.ownerIsAlly)
               && _selectedBuilding.npc)
               {
                  new BuildingsCommand(BuildingsCommand.SHOW_GARRISON_GROUPS,
                     _selectedBuilding).dispatch();
               }
               if (ML.latestPlanet.ssObject.ownerIsPlayer)
               {
                  _selectedBuilding.addEventListener(
                     UpgradeEvent.LEVEL_CHANGE,
                     refreshPriceOrientatedProperties
                  );
                  if (_selectedBuilding.type != BuildingType.MOTHERSHIP
                     && !_selectedBuilding.npc)
                  {
                     GlobalEvent.subscribe_TIMED_UPDATE(global_timedUpdateHandler);
                     refreshDestructProperties();
                     refreshRepairProperties();
                  }
                  if (_selectedBuilding.type == BuildingType.NPC_HALL)
                  {
                     EventBroker.subscribe(GlobalEvent.TIMED_UPDATE, refreshBonusTime);
                  }
               }
               eventPopUpId = new MPermanentEvent(
                  Localizer.string('BuildingSelectedSidebar', 'message.pressOnEmpty')).id;
            }
            else
            {
               EventsController.getInstance().removeEventById(eventPopUpId);
            }

            refreshPriceOrientatedProperties();
            refreshCooldown();
            refreshConstructor();
            if (_selectedBuilding != null && constructor != null)
            {
               constructor.addEventListener(BuildingEvent.QUERY_CHANGE, cancelDrag);
            }
         }
      }

      [Bindable]
      public var constructableObject: * = null;

      private function refreshConstructor(e: Event = null): void
      {
         GlobalEvent.unsubscribe_TIMED_UPDATE(refreshBuiltPart);
         if (_selectedBuilding)
         {
            if (_selectedBuilding.isGhost)
            {
               constructor = ML.latestPlanet.getBuildingById(
                       _selectedBuilding.constructorId);
            }
            else if (_selectedBuilding.constructableType != null)
            {
               constructor = _selectedBuilding;
            }
            else
            {
               constructor = null;
            }
            if (constructor != null && constructor.constructableType != null)
            {
               if (ModelUtil.getModelClass(constructor.constructableType)
                       == ObjectClass.UNIT)
               {
                  constructableObject = ML.latestPlanet.getUnitById(
                          constructor.constructableId);
               }
               else
               {
                  constructableObject = ML.latestPlanet.getBuildingById(
                          constructor.constructableId);
               }
               GlobalEvent.subscribe_TIMED_UPDATE(refreshBuiltPart);
               if (_selectedBuilding.isGhost)
               {
                  for each (var queueEntry: ConstructionQueueEntry in
                          constructor.constructionQueueEntries)
                  {
                     if ((_selectedBuilding.x == queueEntry.params.x)
                             && (_selectedBuilding.y == queueEntry.params.y))
                     {
                        queueEntry.selected = true;
                     }
                     else
                     {
                        queueEntry.selected = false;
                     }
                  }
               }
            }
         }
      }

      private function refreshBuiltPart(e: GlobalEvent): void {
         //if server did not sent updated message or client did not yet received it avoid NPE
         if (constructableObject != null && constructableObject.upgradePart != null) {
            constructableBuiltPart = Upgradable(
               constructableObject.upgradePart).upgradeProgress;
         }
      }

      [Bindable]
      public var constructableBuiltPart: Number;

      public function queueList_dragCompleteHandler(event:DragEvent):void
      {
         var queueList: List = List(event.dragInitiator);
         if (queueList.dragMoveEnabled && !dragCanceled)
         {
            var tempElement: ConstructionQueueEntry = ConstructionQueueEntry(
                    List(event.dragInitiator).selectedItems[0]);
            if (tempElement != null &&
               (constructor.constructionQueueEntries.getItemIndex(tempElement) !=
               tempElement.position))
            {
               EventBroker.subscribe(GBuildingEvent.QUEUE_APROVED, restoreSelection);
               var newPosition: int = tempElement.position> constructor.constructionQueueEntries.getItemIndex(tempElement)?
                  constructor.constructionQueueEntries.getItemIndex(tempElement):
                  constructor.constructionQueueEntries.getItemIndex(tempElement) + 1;
               new ConstructionQueuesCommand(
                  ConstructionQueuesCommand.MOVE,
                  {id: tempElement.id,
                     count: tempElement.count,
                     position: newPosition}
               ).dispatch ();
            }
         }
      }

      public function queueList_dragStartHandler(event: DragEvent): void
      {

         queueList.dropEnabled = true;
         queueList.dragMoveEnabled = true;
         dragCanceled = false;
      }

      private function restoreSelection(e: GBuildingEvent): void
      {
         EventBroker.unsubscribe(GBuildingEvent.QUEUE_APROVED, restoreSelection);
         refreshConstructor();
      }

      public function activate_clickHandler(event:MouseEvent):void
      {
         if (_selectedBuilding.state == Building.ACTIVE)
         {
            new BuildingsCommand(BuildingsCommand.DEACTIVATE, _selectedBuilding).dispatch ();
         }
         else if (_selectedBuilding.state == Building.INACTIVE)
         {
            new BuildingsCommand(BuildingsCommand.ACTIVATE, _selectedBuilding).dispatch ();
         }
      }

      public function infoButton_clickHandler(event:MouseEvent):void
      {
         NC.showInfo(_selectedBuilding);
      }

      public function upgrade_clickHandler(event:MouseEvent):void
      {
         new BuildingsCommand(
            BuildingsCommand.UPGRADE,
            {id: _selectedBuilding.id}
         ).dispatch ();
      }

      private function getStringFromSeconds(seconds: int): String
      {
         return DateUtil.secondsToHumanString(seconds);
      }

      [Bindable]
      public var bonusTime: String = '';

      private function refreshBonusTime(e: GlobalEvent): void
      {
         if (_selectedBuilding.cooldownEndsAt)
         {
            bonusTime = DateUtil.secondsToHumanString((
                    _selectedBuilding.cooldownEndsAt.time -
                    new Date().time)/1000);
         }
      }

      private function global_timedUpdateHandler(e: GlobalEvent): void
      {
         refreshDestructProperties();
         refreshCancelProperties();
         refreshRepairProperties();
         refreshCooldown();
      }

      [Bindable]
      public var builtPart: Number;

      private function refreshCancelProperties(): void
      {
         if (_selectedBuilding != null &&
            _selectedBuilding.upgradePart != null &&
            _selectedBuilding.upgradePart.upgradeEndsAt != null) {
            builtPart = _selectedBuilding.upgradePart.upgradeProgress;
         }
      }

      [Bindable]
      public var cooldownTimeLeft: String = null;

      private function refreshCooldown(): void
      {
         if (_selectedBuilding == null || _selectedBuilding.cooldownEndsAt == null)
         {
            cooldownTimeLeft = null;
            return;
         }
         var timeNow: Number = new Date().time;
         if (timeNow > _selectedBuilding.cooldownEndsAt.time)
         {
            cooldownTimeLeft = null;
            return;
         }
         cooldownTimeLeft = DateUtil.secondsToHumanString(
            (_selectedBuilding.cooldownEndsAt.time - timeNow)/1000);
      }

      private function refreshRepairProperties(): void
      {
         if (_selectedBuilding != null &&
            _selectedBuilding.upgradePart != null &&
            _selectedBuilding.upgradePart.upgradeEndsAt == null)
         {
            if (_selectedBuilding.isDamaged)
            {
               var ssObject: MSSObject = ML.latestPlanet.ssObject;
                missingRepairStorageString = Resource.getMissingStoragesString(
                       ssObject, metalRepairCost, energyRepairCost, zetiumRepairCost);
               missingMassRepairStorageString = Resource.getMissingStoragesString(
                      ssObject, metalMassRepairCost, energyMassRepairCost, zetiumMassRepairCost);

               enoughRepairStorage = (missingRepairStorageString == ''?true:false);
               enoughMassRepairStorage = (missingMassRepairStorageString == ''?true:false);

               if (!enoughRepairStorage)
               {
                  canRepairBuilding = false;
               }
               else
               {
                  canRepairBuilding = metalRepairCost  <= ssObject.metal.currentStock &&
                  energyRepairCost <= ssObject.energy.currentStock &&
                  zetiumRepairCost <= ssObject.zetium.currentStock;
               }
               if (!enoughMassRepairStorage)
               {
                  canMassRepairBuilding = false;
               }
               else
               {
                  canMassRepairBuilding = metalMassRepairCost  <= ssObject.metal.currentStock &&
                  energyMassRepairCost <= ssObject.energy.currentStock &&
                  zetiumMassRepairCost <= ssObject.zetium.currentStock;
               }

               if (canRepairBuilding)
               {
                  repairResLeft = 0;
               }
               else
               {
                  repairResLeft = Resource.getTimeToReachResources
                     (ssObject.metal, ssObject.energy, ssObject.zetium,
                        metalRepairCost, energyRepairCost, zetiumRepairCost);
                  repairResLeftString = getStringFromSeconds(repairResLeft);
               }

               if (canMassRepairBuilding)
               {
                  massRepairResLeft = 0;
               }
               else
               {
                  massRepairResLeft = Resource.getTimeToReachResources
                     (ssObject.metal, ssObject.energy, ssObject.zetium,
                        metalMassRepairCost, energyMassRepairCost, zetiumMassRepairCost);
                  massRepairResLeftString = getStringFromSeconds(massRepairResLeft);
               }
            }
         }
      }

      public function cancelUpgrade(): void
      {
         var popUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
         popUp.confirmButtonLabel = Localizer.string('Popups', 'label.yes');
         popUp.cancelButtonLabel = Localizer.string('Popups', 'label.no');
         var lbl: Label = new Label();
         lbl.minWidth = 300;
         lbl.text = Localizer.string('Popups', 'message.' +
            (_selectedBuilding.upgradePart.level > 0?'cancelUpgrade':'cancelConstructor'));
         popUp.addElement(lbl);
         popUp.title = Localizer.string('Popups', 'title.' +
            (_selectedBuilding.upgradePart.level > 0?'cancelUpgrade':'cancelConstructor'));
         popUp.confirmButtonClickHandler = function (button: Button = null): void
         {
            var _constructor: Building = ML.latestPlanet.getBuildingByConstructable(
               _selectedBuilding.id, ObjectClass.BUILDING);
            new BuildingsCommand(_selectedBuilding.upgradePart.level > 0
                    || _constructor == null
               ? BuildingsCommand.CANCEL_UPGRADE
               : BuildingsCommand.CANCEL_CONSTRUCTOR,
               {
                  'id': (_selectedBuilding.upgradePart.level > 0
                          || _constructor == null
                          ? _selectedBuilding.id
                          : _constructor.id)
               }).dispatch();
         };
         popUp.show();
      }

      public function selfDestruct_clickHandler(event:MouseEvent):void
      {
         if (canDestroyBuilding)
         {
            var popUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
            popUp.confirmButtonLabel = Localizer.string('Popups', 'label.yes');
            popUp.cancelButtonLabel = Localizer.string('Popups', 'label.no');
            var lbl: Label = new Label();
            lbl.minWidth = 300;
            lbl.text = Localizer.string('Popups', 'message.selfDestruct',
                    [_selectedBuilding.name]);
            popUp.addElement(lbl);
            popUp.title = Localizer.string('Popups', 'title.selfDestruct');
            popUp.confirmButtonClickHandler = function (button: Button = null): void
            {
               new BuildingsCommand(BuildingsCommand.SELF_DESTRUCT,
                       {'model': _selectedBuilding,
                        'withCreds': false}).dispatch();
            };
            popUp.show();
         }
         else
         {
            var confirmPopUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
            var confirmLabel: ConfirmCredsLabel = new ConfirmCredsLabel();
            confirmLabel.popUp = confirmPopUp;
            var destCreds: int = Config.getDestructCredits();
            confirmLabel.credsRequired = destCreds;
            confirmLabel.textFlow = TextFlowUtil.importFromString(
               Localizer.string('Credits', 'label.destructPrice', [destCreds]));
            confirmLabel.refreshPopup();
            confirmPopUp.addElement(confirmLabel);
            confirmPopUp.confirmButtonClickHandler = function (button: Button = null): void
            {
               function doDestruct(): void
               {
                  new BuildingsCommand(BuildingsCommand.SELF_DESTRUCT,
                          {'model': _selectedBuilding,
                           'withCreds': true}).dispatch();
               }
               if (confirmLabel.hasEnoughCredits())
               {
                  doDestruct();
               }
               else
               {
                  WaitingCredsPopUp.showPopUp(destCreds, doDestruct);
               }
            };
            confirmPopUp.show();
         }
      }

      public function coin_clickHandler(event:MouseEvent):void
      {
         var accelerator: AccelerateSelector = new AccelerateSelector();
         accelerator.upgradePart = _selectedBuilding.upgradePart;
         var speedPopUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
         accelerator.popUp = speedPopUp;
         speedPopUp.confirmButtonEnabled = false;
         speedPopUp.confirmButtonClickHandler = function(): void
         {
            function doAccelerate(): void
            {
               if (_selectedBuilding.upgradePart.level > 0)
               {
                  new BuildingsCommand(BuildingsCommand.ACCELERATE_UPGRADE,
                     {'id': _selectedBuilding.id,
                        'index': accelerator.selectedAccelerateType}).dispatch();
               }
               else
               {
                  var tempBuilding: Building =
                     ML.latestPlanet.getBuildingByConstructable(
                             _selectedBuilding.id, ObjectClass.BUILDING);
                  if (tempBuilding)
                  {
                     new BuildingsCommand(BuildingsCommand.ACCELERATE_CONSTRUCTOR,
                        {'id': tempBuilding.id,
                           'index': accelerator.selectedAccelerateType}).dispatch();
                  }
                  else
                  {
                     new BuildingsCommand(BuildingsCommand.ACCELERATE_UPGRADE,
                        {'id': _selectedBuilding.id,
                           'index': accelerator.selectedAccelerateType}).dispatch();
                  }
               }
            }
            if (accelerator.hasEnoughCredits())
            {
               doAccelerate();
            }
            else
            {
               WaitingCredsPopUp.showPopUp(accelerator.selectedCost, doAccelerate);
            }
         }
         speedPopUp.addElement(accelerator);
         speedPopUp.show();
      }

      public function moveButton_click(e: MouseEvent): void
      {
         if (ML.player.creds >= Config.getMoveCredits())
         {
            MCSidebar.getInstance().showPrevious();
            new GBuildingEvent(GBuildingEvent.MOVE_INIT, _selectedBuilding);
         }
         else
         {
            UrlNavigate.getInstance().showBuyCreds();
         }
      }

      public function toggleOverdrive(turnOn: Boolean): void
      {
         if (turnOn)
         {
            new BuildingsCommand(BuildingsCommand.ACTIVATE_OVERDRIVE,
               _selectedBuilding).dispatch();
         }
         else
         {
            new BuildingsCommand(BuildingsCommand.DEACTIVATE_OVERDRIVE,
               _selectedBuilding).dispatch();
         }
      }

      public function openCurrent(): void
      {
         openBuilding(_selectedBuilding);
      }

      public function repairBuilding(): void
      {
         new BuildingsCommand(BuildingsCommand.REPAIR,
            _selectedBuilding).dispatch();
      }

      public function massRepairBuilding(): void
      {
         var buildingIds: Array = [];
         for each (var building: Building in ML.latestPlanet.damagedBuildings)
         {
            buildingIds.push(building.id);
         }
         new BuildingsCommand(BuildingsCommand.MASS_REPAIR,
            {'planetId': ML.latestPlanet.id,
            'buildingIds': buildingIds}).dispatch();
      }

      private function refreshDestructProperties(): void
      {
         if (totalCooldown == 0)
         {
            totalCooldown = Config.getBuildingSelfDestructCooldown();
            totalDestructTimeLbl = Localizer.string('BuildingSelectedSidebar', 'destructCooldown.total',
               [DateUtil.secondsToHumanString(totalCooldown)]);
         }
         // TODO ML.latestPlanet gets changed to null when entering new ss or after reset,
         // maby later we whould set priority for these events to remove listeners which calls
         // this method and add them when navigating back to some planet again.
         var proceed:Boolean = ML.latestPlanet != null && ML.latestPlanet.ssObject != null;
         if (proceed && canDestroyBuilding != ML.latestPlanet.ssObject.canDestroyBuilding)
         {
            canDestroyBuilding = ML.latestPlanet.ssObject.canDestroyBuilding;
         }
         if (canDestroyBuilding)
         {
            destructRemainingTime = '';
         }
         else if (proceed)
         {
            destructRemainingTime = DateUtil.secondsToHumanString(int(
               (ML.latestPlanet.ssObject.canDestroyBuildingAt.time - new Date().time)/1000));
         }
      }

      public var queueList: List;

      private var dragCanceled: Boolean = false;

      private function cancelDrag(e: BuildingEvent): void
      {
         if (queueList != null)
         {
            queueList.dropEnabled = false;
            queueList.dragMoveEnabled = false;
            DragManager.acceptDragDrop(null);
            queueList.layout.hideDropIndicator();
            DragManager.showFeedback(DragManager.NONE);
            queueList.drawFocus(false);
            dragCanceled = true;
         }
      }
      
      private function dispatchSelectedBuildingChangeEvent(): void
      {
         if (hasEventListener(BuildingSidebarEvent.SELECTED_CHANGE))
         {
            dispatchEvent(new BuildingSidebarEvent(BuildingSidebarEvent.SELECTED_CHANGE));
         }
      }
   }
}