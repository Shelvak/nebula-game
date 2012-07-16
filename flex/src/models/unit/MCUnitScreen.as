package models.unit
{
   import components.popups.ActionConfirmationPopUp;
   import components.unitsscreen.events.UnitsScreenEvent;

   import controllers.ui.NavigationController;
   import controllers.units.OrdersController;
   import controllers.units.UnitsCommand;

   import flash.events.EventDispatcher;

   import models.ModelLocator;
   import models.location.ILocationUser;
   import models.location.Location;
   import models.movement.MRoute;
   import models.movement.MSquadron;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.core.FlexGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;

   import spark.components.Button;
   import spark.components.Label;
   import spark.components.ToggleButton;

   import utils.Events;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;


   public class MCUnitScreen extends EventDispatcher implements ILocationUser
   {
      
      public function MCUnitScreen(): void
      {
         super();
         ML.additionalLocationUsers.addItem(this);
      }
      
      private static const MAX_FLANKS: int = 2;
      
      public static function getInstance(): MCUnitScreen
      {
         return SingletonFactory.getSingletonInstance(MCUnitScreen);
      }

      public function updateLocationName(id: int, name: String): void {
         if (location is Location
            && Location(location).isSSObject
            && location.id == id)
         {
            Location(location).name = name;
         }
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
      
      public var sourceFlank: UnitsFlank;
      public var sourceUnits: ListCollectionView;
      
      public function set units (value: ListCollectionView): void
      {
         _units = value;
         Unit.sortByHp(_units);
      }
      
      public function get units (): ListCollectionView
      {
         return _units;
      }
      
      public var transformedUnits: ArrayCollection;
      
      [Bindable]
      public var owner: int;
      
      [Bindable]
      public var routes: ArrayCollection = new ArrayCollection();
      public var squads: ListCollectionView;
      
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


      /* ################# */
      /* #### Filters #### */
      /* ################# */

      private function updateIfNeeded(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD || e.kind == CollectionEventKind.REMOVE
            || e.kind == CollectionEventKind.RESET)
         {
            if (hasGroundUnits)
            {
               groundVisible = true;
            }
            if (hasSpaceUnits)
            {
               spaceVisible = true;
            }
            if (!unitsHasChanged)
            {
               unitsHasChanged = true;
               FlexGlobals.topLevelApplication.callLater(
                  dispatchUnitsChangeEvent);
            }
         }
      }
      
      public function prepare(sUnits: ListCollectionView, sLocation: *,
                              sTarget: *, sKind: String, sOwner: int): void
      {
         if (units)
         {
            units.removeEventListener(CollectionEvent.COLLECTION_CHANGE, updateIfNeeded);
         }
         //Set screen values
         units = sUnits;
         units.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateIfNeeded);
         location = sLocation;
         target = sTarget;
         currentKind = sKind;
         owner = sOwner;
         
         //Find out current kind
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
         
         
         if (squads)
         {
            squads.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshRoutes);
         }
         if (location is Location && Location(location).isSSObject)
         {
            squads = Collections.filter(ML.latestPlanet.squadrons,
               function(squad:MSquadron) : Boolean
               {
                  return squad.owner == owner;
               }
            );
         }
         else
         {
            squads = null;
         }
         if (squads)
         {
            squads.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshRoutes);
         }
         refreshRoutes();
         
         
         
         deselectUnits();
         //Prepare currentScreen
         refreshScreen();
         
         dispatchFormationChangeEvent();
      }
      
      public function refreshScreen(): void
      {
         if (currentKind != UnitKind.MOVING)
         {
            createFlanks();
         }
         else
         {
            if (filteredSquadronUnits != null)
            {
               filteredSquadronUnits.refresh();
            }
         }
         
         groundVisible = hasGroundUnits || currentKind == UnitKind.GROUND;
         spaceVisible = hasSpaceUnits || currentKind == UnitKind.SPACE;
         moveVisible = hasMovingUnits || currentKind == UnitKind.MOVING;
         dispatchUnitsChangeEvent();
      }
      
      private var filteredUnits: ListCollectionView;
      
      private function createFlanks(): void
      {
         if (filteredUnits != null)
         {
            filteredUnits.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
            if (filteredUnits != filteredSquadronUnits)
            {
               filteredUnits.list = null;
            }
         }
         buildFlanks();
         if (currentKind != UnitKind.SQUADRON)
         {
            filteredUnits = 
               Collections.filter(_units, function(item: Unit): Boolean
               {
                  return item.kind == currentKind;
               });
         }
         else if (filteredSquadronUnits != null)
         {
            filteredUnits = filteredSquadronUnits;
            dispatchUnitsChangeEvent();
         }
         else
         {
            dispatchUnitsChangeEvent();
            return;
         }
         
         filteredUnits.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshList);
         buildUnits(filteredUnits);
      }
      
      private function buildFlanks(): void
      {
         flanks = new ArrayCollection();
         for (var key: int = 0; key < MAX_FLANKS; key++)
         {
            flanks.addItem(new UnitsFlank(key, owner));
         }
      }
      
      private function buildUnits(unitsList: ListCollectionView): void
      {
         var source: Array = [];
         for each (var unit: Unit in unitsList)
         {
            source.push(new MCUnit(unit, UnitsFlank(flanks.getItemAt(unit.flank))));
         }
         if (transformedUnits != null)
         {
            transformedUnits.removeEventListener(CollectionEvent.COLLECTION_CHANGE, refreshModels);
         }
         transformedUnits = new ArrayCollection(source);
         unitsToFlanks();
      }
      
      private function filteredCollection(flank: UnitsFlank): ListCollectionView
      {
         var source: Array = [];
         for each (var unit: MCUnit in transformedUnits)
         {
            if (unit.flankModel == flank)
            {
               source.push(unit);
            }
         }
         return new ArrayCollection(source);
      }
      
      private function unitsToFlanks(): void
      {
         for each (var flank: UnitsFlank in flanks)
         {
            flank.flankUnits = filteredCollection(flank);
         }
         transformedUnits.addEventListener(CollectionEvent.COLLECTION_CHANGE, refreshModels);
         addEventListener(UnitsScreenEvent.FORMATION_CHANGE, refreshFlanks);
      }
      
      private function refreshFlanks(e: UnitsScreenEvent): void
      {
         var changedUnits: Array = [];
         var _sourceFlank: UnitsFlank = null;
         var _targetFlank: UnitsFlank = null;
         var found: Boolean = false;
         for each (var flank: UnitsFlank in flanks)
         {
            for each (var unit: MCUnit in flank.flankUnits)
            {
               if (unit.flankModel != flank)
               {
                  if (!found)
                  {
                     found = true;
                     _sourceFlank = flank;
                     _targetFlank = unit.flankModel;
                  }
                  changedUnits.push(unit);
               }
            }
            if (found)
            {
               _sourceFlank.removeUnits(changedUnits, false);
               _targetFlank.addUnits(changedUnits);
               dispatchSelectionChangeEvent();
               break;
            }
         }
      }
      
      private function addModels(source: Array): void
      {
         var temp: Object = {};
         for each (var unit: MCUnit in source)
         {
            if (temp[unit.flankModel.nr] == null)
            {
               temp[unit.flankModel.nr] = new Array();
            }
            (temp[unit.flankModel.nr] as Array).push(unit);
         }
         for (var flankNr: String in temp)
         {
            UnitsFlank(flanks.getItemAt(int(flankNr))).addUnits(temp[flankNr] as Array);
         }
      }
      
      private function removeModels(source: Array): void
      {
         var temp: Object = {};
         for each (var unit: MCUnit in source)
         {
            if (temp[unit.flankModel.nr] == null)
            {
               temp[unit.flankModel.nr] = new Array();
            }
            (temp[unit.flankModel.nr] as Array).push(unit);
         }
         for (var flankNr: String in temp)
         {
            UnitsFlank(flanks.getItemAt(int(flankNr))).removeUnits(temp[flankNr] as Array);
         }
      }
      
      private function refreshModels(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               addModels(e.items);
            }
         }
         else if (e.kind == CollectionEventKind.REMOVE)
         {
            if (e.items.length != 0)
            {
               removeModels(e.items);
            }
         }
      }
      
      public function tabChanged(tab: ToggleButton):void
      {
         deselectUnits();
         cancel();
         currentKind = tab.name;
         tab.selected = true;
         if (currentKind == UnitKind.GROUND || currentKind == UnitKind.SPACE)
         {
            NavigationController.getInstance().switchActiveUnitButtonKind(currentKind);
         }
         refreshScreen();
      }

      private var hiddenDispatched: Boolean = false;
      private var formationDispatched: Boolean = false;
      
      public function updateChanges(): void
      {
         if (hasFormationChanges)
         {
            formationDispatched = true;
            new UnitsCommand(UnitsCommand.UPDATE,
               {updates: getChanged()}
            ).dispatch ();
         }
         if (hasHiddenChanges)
         {
            hiddenDispatched = true;
            new UnitsCommand(UnitsCommand.SET_HIDDEN,
               {
                  'planetId': location.id,
                  'unitIds': getHiddenChanged(),
                  'value': true
               }
            ).dispatch ();
         }
         if (hasNotHiddenChanges)
         {
            hiddenDispatched = true;
            new UnitsCommand(UnitsCommand.SET_HIDDEN,
               {
                  'planetId': location.id,
                  'unitIds': getNotHiddenChanged(),
                  'value': false
               }
            ).dispatch ();
         }
      }
      
      private function getChanged(): Object
      {
         var changedUnits: Object = {};
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.stance != unit.unit.stance
               || unit.flankModel.nr != unit.unit.flank)
            {
               changedUnits[unit.unit.id] = [unit.flankModel.nr, unit.stance];
            } 
         }
         return changedUnits;
      }

      private function getHiddenChanged(): Array
      {
         var changedUnits: Array = [];
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.hidden == true && unit.hidden != unit.unit.hidden)
            {
               changedUnits.push(unit.unit.id);
            }
         }
         return changedUnits;
      }

      private function getNotHiddenChanged(): Array
      {
         var changedUnits: Array = [];
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.hidden == false && unit.hidden != unit.unit.hidden)
            {
               changedUnits.push(unit.unit.id);
            }
         }
         return changedUnits;
      }

      public function get hasHiddenChanges(): Boolean
      {
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.hidden == true && unit.hidden != unit.unit.hidden)
            {
               return true;
            }
         }
         return false;
      }

      public function get hasNotHiddenChanges(): Boolean
      {
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.hidden == false && unit.hidden != unit.unit.hidden)
            {
               return true;
            }
         }
         return false;
      }

      public function get hasFormationChanges(): Boolean
      {
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.stance != unit.unit.stance
               || unit.flankModel.nr != unit.unit.flank)
            {
               return true;
            }
         }
         return false;
      }
      
      [Bindable (event="formationChange")]
      public function get hasChanges(): Boolean
      {
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.stance != unit.unit.stance
               || unit.flankModel.nr != unit.unit.flank
                    || unit.hidden != unit.unit.hidden)
            {
               return true;
            } 
         }
         return false;
      }
      
      private var cachedSelection: ArrayCollection = null;
      private var cachedTransporters: ArrayCollection = null;
      
      [Bindable (event="selectionChange")]
      public function get selection(): ArrayCollection
      {
         if (cachedSelection)
         {
            return cachedSelection;
         }
         var _selection: Array = [];
         for each (var flank: UnitsFlank in flanks)
         {
            for each (var unit: MCUnit in flank.selection)
            {
               _selection.push(unit.unit);
            }
         }
         cachedSelection = new ArrayCollection(_selection);
         return cachedSelection;
      }

      [Bindable (event="selectionChange")]
      public function get selectedTransporters(): ArrayCollection
      {
         if (cachedTransporters)
         {
            return cachedTransporters;
         }
         var _selection: Array = [];
         for each (var unit: MCUnit in selection)
         {
            if (ML.technologies.getUnitStorage(unit.unit.type, unit.unit.level) > 0)
            {
               _selection.push(unit.unit);
            }
         }
         cachedTransporters = new ArrayCollection(_selection);
         return cachedTransporters;
      }
      
      [Bindable]
      public var flanks: ArrayCollection;
      
      private function get hasGroundUnits(): Boolean
      {
         for each (var unit: Unit in _units)
         {
            if (unit.kind == UnitKind.GROUND)
            {
               return true;
            }
         }
         return false;
      }
      
      private function get hasSpaceUnits(): Boolean
      {
         for each (var unit: Unit in _units)
         {
            if (unit.kind == UnitKind.SPACE)
            {
               return true;
            }
         }
         return false;
      }
      
      private function get hasMovingUnits(): Boolean
      {
         return routes && routes.length > 0;
      }
      
      public function cancel(): void
      {
         if (transformedUnits)
         {
            transformedUnits.disableAutoUpdate();
            for each(var unit: MCUnit in transformedUnits)
            {
               if (unit.unit.flank != unit.flankModel.nr)
               {
                  unit.flankModel = UnitsFlank(flanks.getItemAt(unit.unit.flank));
               }
               if (unit.unit.stance != unit.stance)
               {
                  unit.stance = unit.unit.stance;
               }
               if (unit.unit.hidden != unit.hidden)
               {
                  unit.hidden = unit.unit.hidden;
               }
            }
            transformedUnits.enableAutoUpdate();
            dispatchFormationChangeEvent();
            deselectUnits();
         }
      }
      
      public function confirmChanges(): void
      {
         transformedUnits.disableAutoUpdate();
         ML.units.disableAutoUpdate();
         for each(var unit: MCUnit in transformedUnits)
         {
            if (unit.unit.flank != unit.flankModel.nr)
            {
               unit.unit.flank = unit.flankModel.nr;
            }
            if (unit.unit.stance != unit.stance)
            {
               unit.unit.stance = unit.stance;
            }
         }
         ML.units.enableAutoUpdate();
         transformedUnits.enableAutoUpdate();
         formationDispatched = false;
         if (!hiddenDispatched)
         {
            refreshScreen();
         }
         dispatchFormationChangeEvent();
      }

      public function confirmHiddenChanges(): void
      {
         if (hiddenDispatched)
         {
            transformedUnits.disableAutoUpdate();
            ML.units.disableAutoUpdate();
            for each(var unit: MCUnit in transformedUnits)
            {
               if (unit.unit.hidden != unit.hidden)
               {
                  unit.unit.hidden = unit.hidden;
               }
            }
            ML.units.enableAutoUpdate();
            transformedUnits.enableAutoUpdate();

            hiddenDispatched = false;

            if (!formationDispatched)
            {
               refreshScreen();
            }
            dispatchFormationChangeEvent();
         }
      }
      
      
      [Bindable (event = 'unitsChange')]
      public function getUnitCount(kind: String): int
      {
         var count: int = 0;
         if (kind == UnitKind.MOVING)
         {
            for each (var route: MRoute in routes)
            {
               for each (var entry: UnitBuildingEntry in route.cachedUnits)
               {
                  count += entry.count;
               }
            }
         }
         else if (kind == UnitKind.SQUADRON)
         {

            count = filteredSquadronUnits == null
               ? 0 : filteredSquadronUnits.length;
         }
         else
         {
            for each (var unit: Unit in _units)
            {
               if (unit.kind == kind)
               {
                  count++;
               }
            }
         }
         return count;
      }
      
      private function get selectionIds(): Array
      {
         var _selection: Array = [];
         
         for each (var flank: UnitsFlank in flanks)
         {
            for each (var unit: MCUnit in flank.selection)
            {
               _selection.push(unit.unit.id);
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
      
      private var filteredSquadronUnits: ListCollectionView;
      
      public function showSquadron(list: ListCollectionView): void
      {
         squadronVisible = true;
         filteredSquadronUnits = list;
         Unit.sortByHp(filteredSquadronUnits);
         currentKind = UnitKind.SQUADRON;
         refreshScreen();
      }
      
      private function buildRoutesFromSquads(): void
      {
         routes.removeAll();
         for each (var squad: MSquadron in squads)
         {
            routes.addItem(squad.route);
         }
         if (squadronVisible)
         {
            if (filteredSquadronUnits.length > 0)
            {
               if (!Unit(filteredSquadronUnits.getItemAt(0)).location.isSSObject)
               {
                  if (currentKind == UnitKind.SQUADRON)
                  {
                     switchToFirstKind();
                     filteredSquadronUnits = null;
                     squadronVisible = false;
                  }
                  else
                  {
                     filteredSquadronUnits = null;
                     squadronVisible = false;
                  }
               }
            }
            else
            {
               if (currentKind == UnitKind.SQUADRON)
               {
                  switchToFirstKind();
                  filteredSquadronUnits = null;
                  squadronVisible = false;
               }
               else
               {
                  filteredSquadronUnits = null;
                  squadronVisible = false;
               }
            }
         }
         dispatchUnitsChangeEvent();
      }
      
      private function switchToFirstKind(): void
      {
         if (hasMovingUnits)
         {
            currentKind = UnitKind.MOVING;
            refreshScreen();
         }
         else if (hasSpaceUnits)
         {
            currentKind = UnitKind.SPACE;
            refreshScreen();
         }
         else if (hasGroundUnits)
         {
            currentKind = UnitKind.GROUND;
            refreshScreen();
         }
         else if (ML.latestPlanet != null && ML.latestPlanet.ssObject != null)
         {
            NavigationController.getInstance().toPlanet(ML.latestPlanet.ssObject);
         }
      }
      
      private function refreshRoutes(e: CollectionEvent = null): void
      {
         buildRoutesFromSquads();
         if (hasMovingUnits)
         {
            moveVisible = true;
         }
      }
      
      public function confirmDismiss():void
      {
         var popUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
         popUp.confirmButtonLabel = getPopupText('label.yes');
         popUp.cancelButtonLabel = getPopupText('label.no');
         var lbl: Label = new Label();
         lbl.minWidth = 300;
         lbl.text = getPopupText('message.dismissUnits');
         popUp.addElement(lbl);
         popUp.title = getPopupText('title.dismissUnits');
         popUp.confirmButtonClickHandler = function (button: Button = null): void
         {
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
            OrdersController.getInstance().issueOrder(selection);
         }
         deselectUnits();
      }
      
      public function selectAll(): void
      {
         for each (var flank: UnitsFlank in flanks)
         {
            flank.selectAll(false);
         }
         dispatchSelectionChangeEvent();
      }
      
      public function deselectUnits(): void
      {
         if (flanks)
         {
            for each (var flank: UnitsFlank in flanks)
            {
               flank.deselectAll(false);
            }
            dispatchSelectionChangeEvent();
         }
      }
      
      public function setStance(stance: int): void
      {
         for each (var flank: UnitsFlank in flanks)
         {
            flank.setStance(stance);
         }
         deselectUnits();
      }

      public function setHidden(hidden: Boolean): void
      {
         for each (var flank: UnitsFlank in flanks)
         {
            flank.setHidden(hidden);
         }
         deselectUnits();
      }
      
      private function refreshList(e: CollectionEvent): void
      {
         if (e.kind == CollectionEventKind.ADD)
         {
            if (e.items.length != 0)
            {
               addUnits(e.items);
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
         else if (e.kind == CollectionEventKind.REMOVE)
         {
            if (e.items.length != 0)
            {
               removeUnits(e.items);
            }
         }
      }
      
      
      private function addUnits(unitsToAdd: Array): void
      {
         for each (var unitToAdd: Unit in unitsToAdd)
         {
            transformedUnits.addItem(new MCUnit(unitToAdd, 
               UnitsFlank(flanks.getItemAt(unitToAdd.flank))));
         }
         if (!unitsHasChanged)
         {
            unitsHasChanged = true;
            FlexGlobals.topLevelApplication.callLater(
               dispatchUnitsChangeEvent);
         }
      }
      
      private var unitsHasChanged: Boolean = false;
      
      private function findUnitIndexAndDeselect(unit: Unit): int
      {
         for (var i: int = 0; i < transformedUnits.length; i++)
         {
            var mUnit: MCUnit = MCUnit(transformedUnits.getItemAt(i));
            if (mUnit.unit == unit)
            {
               mUnit.selected = false;
               return i;
            }
         }
         return -1;
      }
      
      private function removeUnits(unitsToDestroy: Array): void
      {
         for each (var unitToDestroy: Unit in unitsToDestroy)
         {
            var indx: int =  findUnitIndexAndDeselect(unitToDestroy);
            if (indx != -1)
            {
               var flank: UnitsFlank = UnitsFlank(flanks.getItemAt(unitToDestroy.flank));
               transformedUnits.removeItemAt(indx);
               flank.deselectUnit(unitToDestroy.id);
            }
         }
         if (!unitsHasChanged)
         {
            unitsHasChanged = true;
            FlexGlobals.topLevelApplication.callLater(
               dispatchUnitsChangeEvent);
         }
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      public function dispatchFormationChangeEvent(): void {
         dispatchThisEvent(UnitsScreenEvent.FORMATION_CHANGE);
      }

      private function dispatchUnitsChangeEvent(): void {
         unitsHasChanged = false;
         dispatchThisEvent(UnitsScreenEvent.UNIT_COUNT_CHANGE);
      }

      public function dispatchSelectionChangeEvent(): void {
         cachedSelection = null;
         cachedTransporters = null;
         dispatchThisEvent(UnitsScreenEvent.SELECTION_CHANGE);
      }

      private function dispatchThisEvent(event: String): void {
         Events.dispatchSimpleEvent(this, UnitsScreenEvent, event);
      }
      
   }
}