package models.unit
{
   import components.popups.ActionConfirmationPopup;
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   import controllers.units.UnitsCommand;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.location.Location;
   import models.movement.MRoute;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   public class MCUnitScreen extends EventDispatcher
   {
      private static const MAX_FLANKS: int = 2;
      
      public static function getInstance(): MCUnitScreen
      {
         return SingletonFactory.getSingletonInstance(MCUnitScreen);
      }
      
      private var ML: ModelLocator = ModelLocator.getInstance();
      
      [Bindable]
      /**
       * Target location for unit screen, used for attacking NPC buildings 
       */         
      public var target: *;
      
      [Bindable]
      /**
       * location, which is currently opened 
       */         
      public var location: *;
      
      public var _units: ListCollectionView;
      
      public function set units (value: ListCollectionView): void
      {
         _units = value;
         _units.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         sortByHp(_units);
      }
      
      public function get units (): ListCollectionView
      {
         return _units;
      }
      
      [Bindable]
      public var owner: int;
      
      [Bindable]
      public var routes: ListCollectionView;
      
      [Bindable]
      public var groundVisible: Boolean = false;
      [Bindable]
      public var spaceVisible: Boolean = false;
      [Bindable]
      public var moveVisible: Boolean = false;
      [Bindable]
      public var squadronVisible: Boolean = false;
      
      [Bindable]
      public var currentKind: String = UnitKind.GROUND;
      
      public var draggedUnits: Object = {};
      public var hashedUnits: Object = {};
      
      public function prepare(): void
      {
         cancel();
         if (routes)
         {
            routes.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshRoutesButton);
         }
         if (location is Location && Location(location).isSSObject)
         {
            routes = Collections.filter(ML.routes,
               function(route:MRoute) : Boolean
               {
                  return route.currentLocation.equals(location) 
                  && route.owner == owner;
               }
            );
         }
         else
         {
            routes = null;
         }
         if (routes)
         {
            routes.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshRoutesButton);
         }
         groundVisible = hasGroundUnits;
         spaceVisible = hasSpaceUnits;
         moveVisible = hasMovingUnits;
         
         if (currentKind == UnitKind.SPACE && !hasSpaceUnits)
         {
            currentKind = UnitKind.MOVING;
         }
         
         if (currentKind == null)
         {
            if (hasSpaceUnits)
            {
               currentKind = UnitKind.SPACE;
            }
            else
            {
               currentKind = UnitKind.GROUND;
            }
         }
      }
      
      public function cancel(e: Event = null): void
      {
         draggedUnits = {};
         hashedUnits = {};
         buildFlanks();
      }
      
      public function updateChanges(): void
      {
         new UnitsCommand(UnitsCommand.UPDATE,                
            {updates: getChanged()}
         ).dispatch ();
      }
      
      private function getChanged(): Object
      {
         var changedUnits: Object = {};
         for (var unitId: String in draggedUnits)
         {
            var currentUnit: Unit = hashedUnits[unitId];
            if ((currentUnit.flank != draggedUnits[unitId][0]) ||
               (currentUnit.stance != draggedUnits[unitId][1]))
               changedUnits[unitId] = draggedUnits[unitId];
         }
         return changedUnits;
      }
      
      [Bindable (event="formationChange")]
      public function get hasChanges(): Boolean
      {
         for (var unitId: String in draggedUnits)
         {
            var currentUnit: Unit = hashedUnits[unitId];
            if (currentUnit != null && draggedUnits[unitId] != null)
            {
               if ((currentUnit.flank != draggedUnits[unitId][0]) ||
                  (currentUnit.stance != draggedUnits[unitId][1]))
                  return true;
            }
         }
         return false;
      }
      
      [Bindable (event="selectionChange")]
      public function get selection(): Array
      {
         function getSelection(flankList: ArrayCollection): Array
         {
            var _selection: Array = [];
            for each (var flank: UnitsFlank in flankList)
            {
               for each (var unit: Unit in flank.selection)
               {
                  _selection.push(unit);
               }
            }
            return _selection;
         }
         
         return getSelection(currentKind == UnitKind.GROUND?groundFlanks:
            (currentKind == UnitKind.SPACE?spaceFlanks:squadronFlanks));
      }
      
      [Bindable]
      public var groundFlanks: ArrayCollection;
      [Bindable]
      public var spaceFlanks: ArrayCollection;
      [Bindable]
      public var squadronFlanks: ArrayCollection;
      
      
      private function hasUnits(flanks: ArrayCollection): Boolean
      {
         if (flanks)
         {
            for each (var flank: UnitsFlank in flanks)
            {
               if (flank.flank.length > 0)
                  return true;
            }
         }
         return false;
      }
      
      private function get hasGroundUnits(): Boolean
      {
         return hasUnits(groundFlanks);
      }
      
      private function get hasSpaceUnits(): Boolean
      {
         return hasUnits(spaceFlanks);
      }
      
      private function get hasMovingUnits(): Boolean
      {
         return routes && routes.length > 0;
      }
      
      public function updateUnits(unitsHash: Object): void
      {
         for (var unitId: String in unitsHash)
         {
            hashedUnits[unitId] = unitsHash[unitId][2];
            if (draggedUnits[unitId] != null)
            {
               if (unitsHash[unitId][0] == null)
               {
                  draggedUnits[unitId][1] = unitsHash[unitId][1];
               }
               else
               {
                  draggedUnits[unitId][0] = unitsHash[unitId][0];
               }
            }
            else
            {
               if (unitsHash[unitId][0] == null)
               {
                  draggedUnits[unitId]= [unitsHash[unitId][2].flank, unitsHash[unitId][1]];
               }
               else
               {
                  draggedUnits[unitId] = [unitsHash[unitId][0], unitsHash[unitId][2].stance];
               }
            }
         }
         dispatchFormationChangeEvent();
      }
      
      public function confirmChanges(e: Event): void
      {
         ML.units.disableAutoUpdate();
         for (var unitId: String in draggedUnits)
         {
            hashedUnits[unitId].flank = draggedUnits[unitId][0];
            hashedUnits[unitId].stance = draggedUnits[unitId][1];
         }
         ML.units.enableAutoUpdate();
         cancel();
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      [Bindable (event = 'unitsChange')]
      public function getUnitCount(flanks: ArrayCollection): int
      {
         var count: int = 0;
         if (flanks)
         {
            for each (var flank: UnitsFlank in flanks)
            count += flank.flank.length;
         }
         return count;
      }
      
      private function get selectionIds(): Array
      {
         var _selection: Array = [];
         var flankList: ArrayCollection;
         
         flankList = (currentKind == UnitKind.GROUND?groundFlanks:
            (currentKind == UnitKind.SPACE?spaceFlanks:squadronFlanks));
         
         for each (var flank: UnitsFlank in flankList)
         {
            for each (var unit: Unit in flank.selection)
            {
               _selection.push(unit.id);
            }
         }
         return _selection;
      }
      
      private function getPopupText(prop: String, params: Array = null): String
      {
         return Localizer.string('Popups', prop, params);
      }
      
      public function switchToStorage(transporter: Unit): void
      {
         NavigationController.getInstance().showStorage(transporter, units, location);
      }
      
      public function showSquadron(list: ListCollectionView): void
      {
         squadronVisible = true;
         buildSquadronFlanks(list);
         currentKind = UnitKind.SQUADRON;
      }
      
      private function refreshRoutesButton(e: CollectionEvent): void
      {
         if (hasMovingUnits)
         {
            moveVisible = true;
         }
      }
      
      public function confirmDismiss():void
      {
         var popUp: ActionConfirmationPopup = new ActionConfirmationPopup();
         popUp.confirmButtonLabel = getPopupText('label.yes');
         popUp.cancelButtonLabel = getPopupText('label.no');
         var lbl: Label = new Label();
         lbl.minWidth = 300;
         lbl.text = getPopupText('message.dismissUnits');
         popUp.addElement(lbl);
         popUp.title = getPopupText('title.dismissUnits');
         popUp.confirmButtonClickHandler = function (button: Button = null): void
         {
            GlobalFlags.getInstance().lockApplication = true;
            new UnitsCommand(
               UnitsCommand.DISMISS,
               {planetId: ML.latestPlanet.id,
                  unitIds: selectionIds}
            ).dispatch ();
            deselectUnits();
         };
         popUp.show();
      }
      
      public function confirmAttack():void
      {
         if (currentKind == UnitKind.GROUND)
         {
            new UnitsCommand(
               UnitsCommand.ATTACK,
               {planetId: ML.latestPlanet.id,
                  targetId: target.id,
                  unitIds: selectionIds}
            ).dispatch ();
         }
         else
         {
            // ======= ISSUE ORDER ========
            OrdersController.getInstance().issueOrder(new ArrayCollection(selection));
         }
      }
      
      public function deselectUnits(): void
      {
         function deselectFlanks(flanks: ArrayCollection): void
         {
            for each (var flank: UnitsFlank in flanks)
            {
               flank.deselectAll();
            }
         }
         deselectFlanks(groundFlanks);
         deselectFlanks(spaceFlanks);
         deselectFlanks(squadronFlanks);
      }
      
      public function tabChanged(tabName: String):void
      {
         currentKind = tabName;
         if (currentKind == UnitKind.GROUND || currentKind == UnitKind.SPACE)
         {
            NavigationController.getInstance().switchActiveUnitButtonKind(currentKind);
         }
      }
      
      
      private function addUnitToFlank(unit: Unit, flankNr: int): void
      {
         if (unit.kind == UnitKind.GROUND)
         {
            for each (var flank: UnitsFlank in groundFlanks)
            {
               if (flank.nr == flankNr+1)
               {
                  flank.flank.addItem(unit);
                  return;
               }
            }
         }
         else
         {
            for each (flank in spaceFlanks)
            {
               if (flank.nr == flankNr+1)
               {
                  flank.flank.addItem(unit);
                  return;
               }
            }
         }
      }
      
      private function refreshList(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               //TODO OR NOT call later was here
               addUnits(e.items);
               if (hasGroundUnits)
               {
                  groundVisible = true;
               }
               if (hasSpaceUnits)
               {
                  spaceVisible = true;
               }
               //and ended here
            }
         }
         else if (e.kind == CollectionEventKind.REMOVE)
         {
            if (e.items.length != 0)
            {
               removeUnits(e.items);
               if (hasGroundUnits)
               {
                  groundVisible = true;
               }
               if (hasSpaceUnits)
               {
                  spaceVisible = true;
               }
            }
         }
         
      }
      
      private function addUnits(unitsToAdd: Array): void
      {
         for each (var unitToAdd: Unit in unitsToAdd)
         {
            addUnitToFlank(unitToAdd, unitToAdd.flank);
         }
         dispatchUnitsChangeEvent();
      }
      
      private function removeUnits(unitsToDestroy: Array): void
      {
         new GUnitsScreenEvent(GUnitsScreenEvent.DESTROY_UNIT, unitsToDestroy);
         dispatchUnitsChangeEvent();
      }
      
      private function sortByHp(list: ListCollectionView): void
      {
         if (list)
         {
            list.sort = new Sort();
            list.sort.fields = [new SortField('type'), 
               new SortField('hp', false, true, true), new SortField('id', false, false, true)];
            list.refresh();
         }
      }
      
      private function buildFlanks(): void
      {
         groundFlanks = new ArrayCollection();
         spaceFlanks = new ArrayCollection();
         
         var groundFlanksObj: Object = {};
         var spaceFlanksObj: Object = {};
         ML.units.disableAutoUpdate();
         for each (var unit: Unit in units)
         {
            unit.newStance = unit.stance;
            if (unit.kind == UnitKind.GROUND)
            {
               if (groundFlanksObj[unit.flank] == null)
               {
                  groundFlanksObj[unit.flank] = new Array;
               }
               groundFlanksObj[unit.flank].push(unit);
            }
            else
            {
               if (spaceFlanksObj[unit.flank] == null)
               {
                  spaceFlanksObj[unit.flank] = new Array();
               }
               spaceFlanksObj[unit.flank].push(unit);
            }
         }
         ML.units.enableAutoUpdate();
         var key: int;
         for (key = 0; key < MAX_FLANKS; key++)
         {
            groundFlanks.addItem(new UnitsFlank(new ModelsCollection(groundFlanksObj[key]), key+1, owner));
            spaceFlanks.addItem(new UnitsFlank(new ModelsCollection(spaceFlanksObj[key]), key+1, owner));
         }
         dispatchUnitsChangeEvent();
      }
      
      private function buildSquadronFlanks(squadUnits: ListCollectionView): void
      {
         squadUnits.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshSquadron);
         sortByHp(squadUnits);
         squadronFlanks = new ArrayCollection();
         var squadronFlanksObj: Object = {};
         ML.units.disableAutoUpdate();
         for each (var unit: Unit in squadUnits)
         {
            unit.newStance = unit.stance;
            if (squadronFlanksObj[unit.flank] == null)
            {
               squadronFlanksObj[unit.flank] = new Array();
            }
            squadronFlanksObj[unit.flank].push(unit);
         }
         ML.units.enableAutoUpdate();
         
         var key: int;
         for (key = 0; key < MAX_FLANKS; key++)
         {
            squadronFlanks.addItem(new UnitsFlank(new ModelsCollection(squadronFlanksObj[key]), key+1, owner));
         }
         dispatchUnitsChangeEvent();
      }
      
      private function refreshSquadron(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               for each (var unitToAdd: Unit in e.items)
               {
                  for each (var flank: UnitsFlank in squadronFlanks)
                  {
                     if (flank.nr == unitToAdd.flank+1)
                     {
                        flank.flank.addItem(unitToAdd);
                        return;
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
               removeUnits(e.items);
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchFormationChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.FORMATION_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.FORMATION_CHANGE));
         }
      }
      
      private function dispatchUnitsChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.UNIT_COUNT_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.UNIT_COUNT_CHANGE));
         }
      }
      
      public function dispatchSelectionChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.SELECTION_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.SELECTION_CHANGE));
         }
      }
      
   }
}