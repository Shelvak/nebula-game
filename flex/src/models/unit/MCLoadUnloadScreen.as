package models.unit
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.unitsscreen.events.LoadUnloadEvent;
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import controllers.GlobalFlags;
   import controllers.Messenger;
   import controllers.units.UnitsCommand;

   import flash.events.Event;

   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   import globalevents.GResourcesEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelLocator;
   import models.Owner;
   import models.location.Location;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.unit.events.UnitEvent;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import spark.components.ToggleButton;
   
   import utils.SingletonFactory;
   import utils.locale.Localizer;
   
   public class MCLoadUnloadScreen extends EventDispatcher
   {
      public function MCLoadUnloadScreen()
      {
         super();
         EventBroker.subscribe(GResourcesEvent.RESOURCES_CHANGE, dispatchRefreshMaxStorageEvent);
      }
      
      private static const MAX_FLANKS: int = 2;
      
      public static function getInstance(): MCLoadUnloadScreen
      {
         return SingletonFactory.getSingletonInstance(MCLoadUnloadScreen);
      }
      
      [Bindable]
      public var location: * = null;
      [Bindable]
      public var target: * = null;
      [Bindable]
      public var transporter: Unit;
      
      [Bindable]
      public var flanks: ArrayCollection = new ArrayCollection();
      
      public var oldProvider: ListCollectionView;
      
      public function prepare(sUnits: ListCollectionView, sLocation: *,
                              sTarget: *): void
      {
         location = sLocation;
         target = sTarget;
         
         if (transporter != null)
         {
            transporter.removeEventListener(UnitEvent.STORED_CHANGE, refreshVolume)
         }
         
         transporter = (location is Unit? location: target);
         
         if (transporter != null)
         {
            transporter.addEventListener(UnitEvent.STORED_CHANGE, refreshVolume)
         }
         
         if (oldProvider != null)
         {
            oldProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         }
         oldProvider = sUnits;
         sortByHp(oldProvider);
         
         oldProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         
         buildFlanks();
         if (location is Unit ||
            (location is Location && Location(location).player.id == ML.player.id))
         {
            resourcesVisible = true;
         }
         else
         {
            resourcesVisible = false;
         }
         deselectAllButtons();
         if (getUnitCount(flanks) > 0)
         {
            landSelected = true;
         }
         else
         {
            resourcesSelected = true;
         }
         selectionClass.flanks = flanks;
         refreshVolume();
      }
      
      public function refreshScreen(): void
      {
         buildFlanks();
      }
      
      [Bindable (event="selectedResourcesChange")]
      public function get transporterIsFull(): Boolean
      {
         var minVol: int = Math.max(
            Resource.getResourceVolume(1, ResourceType.METAL),
            Resource.getResourceVolume(1, ResourceType.ENERGY),
            Resource.getResourceVolume(1, ResourceType.ZETIUM));
         return (transporter.transporterStorage - transporter.stored < minVol);
      }
      
      [Bindable (event="selectedResourcesChange")]
      public function get planetIsEmpty(): Boolean
      {
         return (!transporterIsFull && getMaxStock(ResourceType.METAL) == 0
            && getMaxStock(ResourceType.ENERGY) == 0 && getMaxStock(ResourceType.ZETIUM) == 0);
      }
      
      [Bindable (event="selectedResourcesChange")]
      public function getMaxStock(resource: String): Number
      {
         var possibleStore: Number = 
            (location is Unit?
               (Math.min(transporter[resource], Resource(ML.latestPlanet.ssObject[resource]).maxStock - 
                  Resource(ML.latestPlanet.ssObject[resource]).currentStock))
               :(Math.min(
                  Resource.getResourcesForVolume(transporter.transporterStorage - transporter.stored - 
                     getOtherSelected(resource) - unitsSelectedVolume, resource),
                  Resource(ML.latestPlanet.ssObject[resource]).currentStock)));
         rebuildWarning();
         return Math.max(0, Math.floor(possibleStore));
      }
      
      [Bindable]
      public var missingStorageString: String = '';
      
      private function rebuildWarning(): void
      {
         var missingStorages: Array = [];
         if ((location is Unit) && ((ML.latestPlanet.ssObject.metal.maxStock -
            ML.latestPlanet.ssObject.metal.currentStock) < 1) && (transporter.metal > 0))    
         {
            missingStorages.push(ResourceType.METAL);
         }
         if ((location is Unit) && ((ML.latestPlanet.ssObject.energy.maxStock -
            ML.latestPlanet.ssObject.energy.currentStock) < 1) && (transporter.energy > 0))
         {
            missingStorages.push(ResourceType.ENERGY);
         }
         if ((location is Unit) && ((ML.latestPlanet.ssObject.zetium.maxStock -
            ML.latestPlanet.ssObject.zetium.currentStock) < 1) && (transporter.zetium > 0))
         {
            missingStorages.push(ResourceType.ZETIUM);
         }
         
         var tempStorageString: String = '';
         var i: int = 0;
         for each (var res: String in missingStorages)
         {
            if (i > 0)
            {
               if (i == missingStorages.length - 1)
               {
                  tempStorageString += ' '+Localizer.string('Resources', 'and')+' ';
               }
               else
               {
                  tempStorageString += ', ';
               }
            }
            i++;
            tempStorageString += Localizer.string('Resources', 'additionalStorage.resource', [res]);
         }
         tempStorageString = missingStorages.length == 0
            ? ''
            : Localizer.string('Units', 'label.planetFull', [
               tempStorageString, (missingStorages.length == 1 ? 'is' : 'are')
            ]);
         if (missingStorageString != tempStorageString)
         {
            missingStorageString = tempStorageString;
         }
      }
      
      [Bindable (event="selectedResourcesChange")]
      private function getOtherSelected(resource: String = ''): int
      {
         var selectedTotal: int = 0;
         if (resource != ResourceType.METAL)
            selectedTotal += Resource.getResourceVolume(metalSelectedVal, ResourceType.METAL);
         if (resource != ResourceType.ENERGY)
            selectedTotal += Resource.getResourceVolume(energySelectedVal, ResourceType.ENERGY);
         if (resource != ResourceType.ZETIUM)
            selectedTotal += Resource.getResourceVolume(zetiumSelectedVal, ResourceType.ZETIUM);
         return selectedTotal;
      }
      
      private function dispatchRefreshMaxStorageEvent(e: Event = null): void
      {
         dispatchEvent(new UnitEvent(UnitEvent.SELECTED_RESOURCES_CHANGE));
      }
      
      public function selectedResourcesChangeHandler(event:UnitEvent):void
      {
         dispatchRefreshMaxStorageEvent();
         refreshVolume();
      }
      
      [Bindable]
      public var landSelected: Boolean;
      [Bindable]
      public var resourcesSelected: Boolean;
      
      [Bindable]
      public var resourcesVisible: Boolean;
      
      private function deselectAllButtons(): void
      {
         landSelected = false;
         resourcesSelected = false;
      }
      
      public function tglButton_clickHandler(event:MouseEvent):void
      {
         deselectAllButtons();
         this[ToggleButton(event.currentTarget).name + 'Selected'] = true;
         dispatchRefreshMaxStorageEvent();
      }
      
      [Bindable (event = 'unitsChange')]
      public function getUnitCount(_flanks: ArrayCollection): int
      {
         var count: int = 0;
         
         for each (var flank: LoadUnloadFlank in _flanks)
         count += flank.flankUnits.length;
         
         return count;
      }
      
      private function get selectionIds(): Array
      {
         var _selection: Array = [];
         for each (var flank: LoadUnloadFlank in flanks)
         {
            for each (var unit: MCUnit in flank.selection)
            {
               _selection.push(unit.unit.id);
            }
         }
         return _selection;
      }
      
      public function confirmTransfer(): void
      {
         var _selectionIds: Array = selectionIds;
         if (_selectionIds.length > 0)
         {
            GlobalFlags.getInstance().lockApplication = true;
            if (target is Unit)
            {
               new UnitsCommand(
                  UnitsCommand.LOAD,
                  {
                     transporterId: target.id,
                     unitIds: _selectionIds
                  }).dispatch();
            }
            else
            {
               new UnitsCommand(
                  UnitsCommand.UNLOAD,
                  {
                     transporterId: location.id,
                     unitIds: _selectionIds
                  }).dispatch();
            }
         }
         if (metalSelectedVal > 0 || energySelectedVal > 0 || zetiumSelectedVal > 0)
         {
            GlobalFlags.getInstance().lockApplication = true;
            if (target is Unit)
            {
               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: target.id,
                     metal: metalSelectedVal,
                     energy: energySelectedVal,
                     zetium: zetiumSelectedVal
                  }).dispatch();
            }
            else
            {
               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: location.id,
                     metal: -1 * metalSelectedVal,
                     energy: -1 * energySelectedVal,
                     zetium: -1 * zetiumSelectedVal
                  }).dispatch();
            }
         }
         deselectAllResources()
         deselectAllUnits();
         refreshVolume();
      }
      
      private function sortByHp(list: ListCollectionView): void
      {
         list.sort = new Sort();
         list.sort.fields = [new SortField('type'), 
            new SortField('hp', false, true, true), new SortField('id', false, false, true)];
         list.refresh();
      }
      
      private function dispatchUnitsChangeEvent(): void
      {
         dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.UNIT_COUNT_CHANGE));
      }
      
      private function refreshList(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               for each (var unitToAdd: Unit in e.items)
               {
                  for each (var flank: LoadUnloadFlank in flanks)
                  {
                     if (flank.nr == (unitToAdd.flank))
                     {
                        flank.flankUnits.addItem(new MCUnit(unitToAdd, flank, true));
                     }
                  }
               }
               dispatchUnitsChangeEvent();
            }
         }
         else if (e.kind == CollectionEventKind.REMOVE)
         {
            if (e.items.length != 0)
            {
               for each (var unitToRemove: Unit in e.items)
               {
                  for each (flank in flanks)
                  {
                     if (flank.nr == (unitToRemove.flank))
                     {
                        flank.removeUnit(unitToRemove);
                     }
                  }
               }
               dispatchUnitsChangeEvent();
               refreshVolume();
            }
         }
      }
      
      private function get unitsSelectedVolume(): int
      {
         var volumeTotal: int = 0;
         for each (var flank: LoadUnloadFlank in flanks)
         {
            for each (var model: MCUnit in flank.selection)
            {
               volumeTotal += model.unit.volume;
            }
         }
         return volumeTotal;
      }
      
      [Bindable]
      public var metalSelectedVal: int = 0;
      [Bindable]
      public var energySelectedVal: int = 0;
      [Bindable]
      public var zetiumSelectedVal: int = 0;
      
      public function selectAllResources(): void
      {
         metalSelectedVal = getMaxStock(ResourceType.METAL);
         energySelectedVal = getMaxStock(ResourceType.ENERGY);
         zetiumSelectedVal = getMaxStock(ResourceType.ZETIUM);
      }
      
      public function deselectAllResources(): void
      {
         metalSelectedVal = 0;
         energySelectedVal = 0;
         zetiumSelectedVal = 0;
      }
      
      public function selectAllUnits(): void
      {
         if (!selectionClass.selectAll())
         {
            Messenger.show(Localizer.string('Units', 'message.notSelected'), 
               Messenger.SHORT);
         }
         refreshVolume();
      }
      
      public function deselectAllUnits(): void
      {
         for each (var flank: LoadUnloadFlank in flanks)
         {
            flank.deselectAll(false);
         }
         refreshVolume();
      }
      
      [Bindable (event="selectedVolumeChanged")]
      public function get volume(): int
      {
         var volumeTotal: int = 0;
         volumeTotal += unitsSelectedVolume;
         volumeTotal += getOtherSelected();
         return volumeTotal;
      }
      
      public var selectionClass: LoadUnloadSelection = new LoadUnloadSelection();
      
      public function refreshVolume(e: UnitEvent = null): void
      {
         selectionClass.freeStorage = (target is Unit
            ? transporter.transporterStorage - transporter.stored - volume : -1);
         dispatchVolumeChangeEvent();
      }
      /**
       var selectedVolume: int = volume;
       if (location is Unit)
       {
       Unit(location).selectedVolume =  -1 * selectedVolume;
       }
       else
       {
       Unit(target).selectedVolume = selectedVolume;
       }
       */      
      
      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      private function buildFlanks(): void
      {
         flanks.removeAll();
         var tempObj: Object = {};
         for each (var unit: Unit in oldProvider)
         {
            if (tempObj[unit.flank] == null)
            {
               tempObj[unit.flank] = new Array();
            }
            tempObj[unit.flank].push(new MCUnit(unit, null, true));
         }
         for (var key: int = 0; key < MAX_FLANKS; key++)
         {
            flanks.addItem(new LoadUnloadFlank(
               new ArrayCollection(tempObj[key] as Array), key, Owner.PLAYER));
         }
         
         dispatchUnitsChangeEvent();
      }
      
      private function dispatchVolumeChangeEvent(): void
      {
         if (hasEventListener(LoadUnloadEvent.SELECTED_VOLUME_CHANGED))
         {
            dispatchEvent(new LoadUnloadEvent(LoadUnloadEvent.SELECTED_VOLUME_CHANGED));
         }
      }
   }
}