package models.healing
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import utils.ApplicationLocker;
   import controllers.Messenger;
   import controllers.units.UnitsCommand;
   
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   import globalevents.GResourcesEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.Owner;
   import models.building.Building;
   import models.unit.MCUnit;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import spark.components.ToggleButton;
   
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   public class MCHealingScreen extends EventDispatcher
   {
      
      public function MCHealingScreen()
      {
         super();
      }
      
      private static const MAX_FLANKS: int = 2;
      
      public static function getInstance(): MCHealingScreen
      {
         return SingletonFactory.getSingletonInstance(MCHealingScreen);
      }
      
      public function prepare(sUnits: ListCollectionView, sLocation: *): void
      {
         //Set screen values
         location = sLocation;
         selectionClass.clear();
         selectionClass.center = location;         
         if (oldProvider != null)
         {
            oldProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         }
         oldProvider = Collections.filter(sUnits, function (item: Unit): Boolean
         {
            return item.hp < item.hpMax;
         });
         Unit.sortByHp(oldProvider);
         
         oldProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         
         buildFlanks();
         deselectAllButtons();
         if (getUnitCount(selfFlanks) > 0)
         {
            selfSelected = true;
         }
         else if (getUnitCount(allyFlanks) > 0)
         {
            napSelected = true;
         }
         else if (getUnitCount(napFlanks) > 0)
         {
            allySelected = true;
         }
         else
         {
            selfSelected = true;
         }
         selectionClass.flanks = currentFlanks;
         selectionClass.allFlanks = [selfFlanks, allyFlanks, napFlanks];
         deselectAllFlankSets();
         refreshPrice();
      }
      
      private function deselectAllFlankSets(): void
      {
         function deselectGivenFlanks(flankSet: ArrayCollection): void
         {
            for each (var flank: MHealFlank in flankSet)
            {
               flank.deselectAll();
            }
         }
         deselectGivenFlanks(selfFlanks);
         deselectGivenFlanks(allyFlanks);
         deselectGivenFlanks(napFlanks);
      }
      
      [Bindable]
      public var selfSelected: Boolean;
      [Bindable]
      public var allySelected: Boolean;
      [Bindable]
      public var napSelected: Boolean;
      
      private function get currentFlanks(): ArrayCollection
      {
         if (selfSelected)
         {
            return selfFlanks;
         }
         else if (napSelected)
         {
            return napFlanks;
         }
         else
         {
            return allyFlanks;
         }
         
      }
      
      private function get selectionIds(): Array
      {
         var _selection: Array = [];
         for each (var flankSet: ArrayCollection in selectionClass.allFlanks)
         {
            for each (var flank: MHealFlank in flankSet)
            {
               for each (var model: MCUnit in flank.selection)
               {
                  _selection.push(model.unit.id);
               }
            }
         }
         return _selection;
      }
      
      public function confirmHeal(): void
      {
         var _selectionIds: Array = selectionIds;
         if (_selectionIds.length > 0)
         {
            new UnitsCommand(
               UnitsCommand.HEAL,
               {
                  buildingId: location.id,
                  unitIds: _selectionIds
               }).dispatch();
         }
      }
      
      private var selectionClass: HealingSelection = new HealingSelection();
      
      private function cleanFlanks(): void
      {
         selfFlanks.removeAll();
         allyFlanks.removeAll();
         napFlanks.removeAll();
      }
      
      private function buildFlanks(): void
      {
         cleanFlanks();
         var tempSelfObj: Object = {};
         var tempAllyObj: Object = {};
         var tempNapObj: Object = {};
         for each (var unit: Unit in oldProvider)
         {
            var tempObj: Object = unit.owner == Owner.PLAYER?tempSelfObj
               :(unit.owner == Owner.ALLY?tempAllyObj:tempNapObj);
            var newUnit: MCUnit = new MCUnit(unit);
            if (tempObj[unit.flank] == null)
            {
               tempObj[unit.flank] = new Array();
            }
            tempObj[unit.flank].push(newUnit);
         }
         for (var key: int = 0; key < MAX_FLANKS; key++)
         {
            selfFlanks.addItem(new MHealFlank(new ArrayCollection(tempSelfObj[key]), key,
               Owner.PLAYER, selectionClass));
            napFlanks.addItem(new MHealFlank(new ArrayCollection(tempNapObj[key]), key,
               Owner.NAP, selectionClass));
            allyFlanks.addItem(new MHealFlank(new ArrayCollection(tempAllyObj[key]), key,
               Owner.ALLY, selectionClass));
         }
         dispatchUnitsChangeEvent();
      }
      
      private function refreshList(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               for each (var unitToAdd: Unit in e.items)
               {
                  var cFlanks: ArrayCollection = 
                     unitToAdd.owner == Owner.PLAYER? selfFlanks
                     : (unitToAdd.owner == Owner.ALLY?allyFlanks:napFlanks);
                  for each (var flank: MHealFlank in cFlanks)
                  {
                     if (flank.nr == (unitToAdd.flank))
                     {
                        flank.flankUnits.addItem(new MCUnit(unitToAdd, flank));
                     }
                  }
               }
            }
         }
         else if (e.kind == CollectionEventKind.REMOVE)
         {
            if (e.items.length != 0)
            {
               for each (var unitToRemove: Unit in e.items)
               {
                  var tFlanks: ArrayCollection = 
                     unitToRemove.owner == Owner.PLAYER? selfFlanks
                     : (unitToRemove.owner == Owner.ALLY?allyFlanks:napFlanks);
                  for each (var rflank: MHealFlank in tFlanks)
                  {
                     if (rflank.nr == (unitToRemove.flank))
                     {
                        rflank.removeUnit(unitToRemove);
                     }
                  }
               }
            }
         }
         dispatchUnitsChangeEvent();
      }
      
      public function selectAll(onlyHealable: Boolean = false): void
      {
         if (!selectionClass.selectAll(onlyHealable))
         {
            Messenger.show(Localizer.string('Units', 'message.noResources'), Messenger.SHORT);
         }
         refreshPrice();
      }
      
      public function selectNone(): void
      {
         if (currentFlanks != null)
         {
            for each (var flank: MHealFlank in currentFlanks)
            {
               flank.deselectAll(false);
            }
            refreshPrice();
         }
      }
      
      [Bindable (event="healingPriceChange")]
      public function get price(): HealPrice
      {
         return _price;
      }
      
      public function set price(value: HealPrice): void
      {
         _price = value;
         dispatchPriceChangedEvent();
      }
      
      private var _price: HealPrice
      /**
       * refreshed HealPrice object with price for all selected units
       * signs null if there is no selection
       **/
      public function refreshPrice(): void
      {
         var _selection: Array = selection;
         if (_selection.length == 0 || !location || !location.upgradePart)
         {
            price = null;
         }
         else
         {
            price = HealPrice.calculateHealingPrice(_selection, location.upgradePart.level, location.type);
         }
         selectionClass.selectedPrice = price;
      }
      
      private function get selection(): Array
      {
         var _selection: Array = [];
         for each (var flankSet: ArrayCollection in selectionClass.allFlanks)
         {
            for each (var flank: MHealFlank in flankSet)
            {
               for each (var unit: MCUnit in flank.selection)
               {
                  _selection.push(unit);
               }
            }
         }
         return _selection;
      }
      
      private function deselectAllButtons(): void
      {
         selfSelected = false;
         napSelected = false;
         allySelected = false;
      }
      
      
      public function unitsButton_clickHandler(event:MouseEvent):void
      {
         deselectAllButtons();
         this[ToggleButton(event.currentTarget).name+'Selected'] = true;
         selectionClass.flanks = currentFlanks;
      }
      
      [Bindable (event = 'unitsChange')]
      public function getUnitCount(_flanks: ArrayCollection): int
      {
         var count: int = 0;
         if (_flanks)
         {
            for each (var flank: MHealFlank in _flanks)
            count += flank.flankUnits.length;
         }
         return count;
      }
      
      private function dispatchUnitsChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.UNIT_COUNT_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.UNIT_COUNT_CHANGE));
         }
      }
      
      private function dispatchPriceChangedEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.HEALING_PRICE_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.HEALING_PRICE_CHANGE));
         }
      }
      
      [Bindable]
      public var location: Building = null;
      
      [Bindable]
      public var selfFlanks: ArrayCollection = new ArrayCollection();
      [Bindable]
      public var napFlanks: ArrayCollection = new ArrayCollection();
      [Bindable]
      public var allyFlanks: ArrayCollection = new ArrayCollection();
      
      private var oldProvider: ListCollectionView;
   }
}