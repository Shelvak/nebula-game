/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:10 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import com.developmentarc.core.utils.EventBroker;

   import config.Config;

   import controllers.units.UnitsCommand;

   import flash.events.EventDispatcher;

   import globalevents.GResourcesEvent;

   import globalevents.GUnitEvent;

   import models.MWreckage;

   import models.ModelLocator;
   import models.Owner;
   import models.factories.UnitFactory;

   import models.location.ILocationUser;
   import models.location.Location;
   import models.location.LocationType;
   import models.planet.events.MPlanetEvent;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;
   import models.unit.MLoadableResource;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;

   import utils.ModelUtil;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.datastructures.Collections;

   public class MCAutoLoad extends EventDispatcher implements ILocationUser{
      public function MCAutoLoad() {
         super();
         ML.additionalLocationUsers.addItem(this);
      }

      public static function getInstance(): MCAutoLoad
      {
         return SingletonFactory.getSingletonInstance(MCAutoLoad);
      }

      [Bindable]
      public var location: * = null;
      [Bindable]
      public var target: * = null;

      private var transporters: ArrayCollection;

      [Bindable]
      public var loadables: ArrayCollection;

      public function updateLocationName(id: int, name: String): void {
         if (location is Location
            && Location(location).isSSObject
            && location.id == id)
         {
            Location(location).name = name;
         }
         if (target is Location
            && Location(target).isSSObject
            && target.id == id)
         {
            Location(target).name = name;
         }
      }

      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }

      public function prepare(_transporters: ArrayCollection, sLocation: *,
                               sTarget: *): void
      {
         location = sLocation;
         target = sTarget;
         transporters = _transporters;
         resetScreen();
      }

      public static const STATE_LOADING: int = 1;
      public static const STATE_UNLOADING: int = 2;

      [Bindable]
      public var state: int;

      private var filteredWreckages: ListCollectionView = null;

      private function refreshWreck(e: CollectionEvent = null): void {
         var wreckage: MWreckage = filteredWreckages.length > 0
            ? MWreckage(filteredWreckages.getItemAt(0))
            : null;
         metal.count = wreckage.metal;
         energy.count = wreckage.energy;
         zetium.count = wreckage.zetium;
      }

      private var metal: MLoadableResource;
      private var energy: MLoadableResource;
      private var zetium: MLoadableResource;
      private var allResources: MLoadableAllResources;
      private var allUnits: MLoadableAllUnits;

      private var inPlanet: Boolean;

      public function switchState(): void
      {
         if (state == STATE_LOADING)
         {
            state = STATE_UNLOADING;
         }
         else
         {
            state = STATE_LOADING;
         }
         var temp: * = target;
         target = location;
         location = temp;
         resetScreen();
      }

      private function addUnitLoadables(e: GUnitEvent): void
      {
         EventBroker.unsubscribe(GUnitEvent.UNITS_SHOWN, addUnitLoadables);
         var storedUnits: ListCollectionView = Collections.filter(ML.units,
            function (unit: Unit): Boolean
            {
               return unit.location.type == LocationType.UNIT;
            }
         );

         var cachedUnits: ArrayCollection = UnitFactory.buildCachedUnitsFromUnits(
            storedUnits
         );
         for each (var unit: UnitBuildingEntry in cachedUnits)
         {
            var unitType: String = ModelUtil.getModelSubclass(unit.type);
            var loadable: MLoadableUnit = new MLoadableUnit(unitType, unit.count);
            allUnits.count += unit.count;
            loadables.addItem(loadable);
         }
         updateMinVolume();
      }

      private function resetScreen(e: MPlanetEvent = null): void
      {
         if (ML.latestPlanet != null)
         {
            ML.latestPlanet.removeEventListener(MPlanetEvent.UNIT_REFRESH_NEEDED,
               resetScreen);
         }
         EventBroker.unsubscribe(GResourcesEvent.RESOURCES_CHANGE,
            updateResourcesIcons);
         ML.units.removeStoredUnits();
         if (filteredWreckages != null)
         {
            filteredWreckages.removeEventListener(
              CollectionEvent.COLLECTION_CHANGE, refreshWreck
            );
         }
         filteredWreckages = null;
         var temp: ArrayCollection = new ArrayCollection();
         allResources = new MLoadableAllResources();
         metal = new MLoadableResource(ResourceType.METAL);
         energy = new MLoadableResource(ResourceType.ENERGY);
         zetium = new MLoadableResource(ResourceType.ZETIUM);
         allUnits = new MLoadableAllUnits();
         if (!(target == null && Location(location).type == LocationType.SS_OBJECT
            && !MCLoadUnloadScreen.planetResourcesLoadable(
            ML.latestPlanet.ssObject.owner)))
         {
            temp.addItem(allResources);
            temp.addItem(metal);
            temp.addItem(energy);
            temp.addItem(zetium);
         }
         if (target == null && Location(location).type == LocationType.SS_OBJECT)
         {
            // LOADING IN PLANET
            state = STATE_LOADING;
            inPlanet = true;
            temp.addItem(allUnits);
            var ssObject: MSSObject = ML.latestPlanet.ssObject;
            metal.count = ssObject.metal.currentStock;
            energy.count = ssObject.energy.currentStock;
            zetium.count = ssObject.zetium.currentStock;
            var cachedUnits: ArrayCollection = UnitFactory.buildCachedUnitsFromUnits(
               ML.latestPlanet.getActiveUnits(Owner.PLAYER, UnitKind.GROUND)
            );
            for each (var unit: UnitBuildingEntry in cachedUnits)
            {
               var unitType: String = ModelUtil.getModelSubclass(unit.type);
               var loadable: MLoadableUnit = new MLoadableUnit(unitType, unit.count);
               allUnits.count += unit.count;
               temp.addItem(loadable);
            }
            ML.latestPlanet.addEventListener(MPlanetEvent.UNIT_REFRESH_NEEDED,
               resetScreen);
            EventBroker.subscribe(GResourcesEvent.RESOURCES_CHANGE,
               updateResourcesIcons);
         }
         else if (target == null)
         {
            //Loading everything from space sector
            state = STATE_LOADING;
            inPlanet = false;
            filteredWreckages = (Location(location).isSolarSystem
              ? ML.latestSSMap.wreckages
              : ML.latestGalaxy.wreckages);
            filteredWreckages = Collections.filter(filteredWreckages,
              function (item: MWreckage): Boolean {
                 return item.currentLocation.equals(location);
              });

            filteredWreckages.addEventListener(
              CollectionEvent.COLLECTION_CHANGE, refreshWreck
            );
            refreshWreck();
         }
         else if (location == null && Location(target).type == LocationType.SS_OBJECT)
         {
            //Unload everything to ss Object
            state = STATE_UNLOADING;
            inPlanet = true;

            temp.addItem(allUnits);
            var transporterIds: Array = [];
            for each (var transporter: Unit in transporters)
            {
               metal.count += transporter.metal;
               energy.count += transporter.energy;
               zetium.count += transporter.zetium;
               transporterIds.push(transporter.id);
            }
            ML.units.removeStoredAfterScreenChange();
            EventBroker.subscribe(GUnitEvent.UNITS_SHOWN, addUnitLoadables);
            new UnitsCommand(UnitsCommand.SHOW,
              {"unitIds": transporterIds}).dispatch();
         }
         else
         {
            //Unload everything to space sector
            for each (transporter in transporters)
            {
               metal.count += transporter.metal;
               energy.count += transporter.energy;
               zetium.count += transporter.zetium;
            }
            state = STATE_UNLOADING;
            inPlanet = false;
         }
         loadables = temp;
         refreshAllResourcesCount();
         updateMinVolume();
      }

      private function updateResourcesIcons(e: GResourcesEvent): void
      {
         if (state == STATE_LOADING && inPlanet &&
            ML.latestPlanet != null && ML.latestPlanet.ssObject != null)
         {
            var ssObject: MSSObject = ML.latestPlanet.ssObject;
            metal.count = ssObject.metal.currentStock;
            energy.count = ssObject.energy.currentStock;
            zetium.count = ssObject.zetium.currentStock;
         }
         else
         {
            EventBroker.unsubscribe(GResourcesEvent.RESOURCES_CHANGE, updateResourcesIcons);
         }
      }

      private function refreshAllResourcesCount(): void
      {
         allResources.count = metal.count + energy.count + zetium.count;
      }

      public function transferAllResources(): void
      {
         if (state == STATE_LOADING)
         {
            loadAllResources();
         }
         else
         {
            unloadAllResources();
         }
         updateMinVolume();
      }

      private function updateMinVolume(): void
      {
         var maxVolume: int = 0;
         if (state == STATE_LOADING)
         {
            for each (var transporter: Unit in transporters)
            {
               maxVolume = Math.max(ML.technologies.getUnitStorage(
                  transporter.type, transporter.level) - transporter.stored,
                  maxVolume
               );
            }
         }
         else if (inPlanet)
         {
            maxVolume = MLoadable.PLANET_STORAGE;
         }
         else
         {
            maxVolume = int.MAX_VALUE;
         }
         var anyUnitEnabled: Boolean = false;
         for each (var loadable: MLoadable in loadables)
         {
            loadable.setMaxVolume(maxVolume);
            if (loadable is MLoadableUnit && MLoadableUnit(loadable).enabled)
            {
               anyUnitEnabled = true;
            }
         }
         allResources.anyResourceEnabled =
            metal.enabled || energy.enabled || zetium.enabled;
         allUnits.anyUnitEnabled = anyUnitEnabled;
      }

      public function transferResource(type: String): void
      {
         if (state == STATE_LOADING)
         {
            loadResource(type);
         }
         else
         {
            unloadResource(type);
         }
         updateMinVolume();
      }

      private function loadAllResources(): void
      {
         for each (var transporter: Unit in transporters)
         {
            var freeSpace: int = ML.technologies.getUnitStorage(transporter.type,
               transporter.level) - transporter.stored;
            if (freeSpace > 0)
            {
               var volumeReserved: int = 0;

               var metalToLoad: int = Math.min(metal.count,
                  Resource.getResourcesForVolume(freeSpace, ResourceType.METAL));
               volumeReserved += Resource.getResourceVolume(
                  metalToLoad, ResourceType.METAL);

               var energyToLoad: int = Math.min(energy.count,
                  Resource.getResourcesForVolume(freeSpace - volumeReserved,
                     ResourceType.ENERGY));
               volumeReserved += Resource.getResourceVolume(
                  energyToLoad, ResourceType.ENERGY);

               var zetiumToLoad: int = Math.min(zetium.count,
                  Resource.getResourcesForVolume(freeSpace - volumeReserved,
                     ResourceType.ZETIUM));

               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: transporter.id,
                     metal: metalToLoad,
                     energy: energyToLoad,
                     zetium: zetiumToLoad
                  }).dispatch();

               metal.count -= metalToLoad;
               energy.count -= energyToLoad;
               zetium.count -= zetiumToLoad;

               if (!(metal.count > 0 || energy.count > 0 || zetium.count > 0))
               {
                  break;
               }
            }
         }
         refreshAllResourcesCount();
      }

      private function unloadResource(type: String): void
      {
         for each (var transporter: Unit in transporters)
         {
            var ssObject: MSSObject;
            var resource: Resource;
            if (inPlanet)
            {
               ssObject = ML.latestPlanet.ssObject;
               resource = Resource(ssObject[type]);
            }
            var dontCheck: Boolean = !inPlanet || ssObject.metal.unknown;
            var amountToUnload: int = dontCheck
               ? transporter[type]
               : Math.min(Resource(ssObject[type]).maxStock - resource.currentStock,
                  transporter[type]);
            if (amountToUnload > 0)
            {
               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: transporter.id,
                     metal: type == ResourceType.METAL ? -1 * amountToUnload : 0,
                     energy: type == ResourceType.ENERGY ? -1 * amountToUnload : 0,
                     zetium: type == ResourceType.ZETIUM ? -1 * amountToUnload : 0
                  }).dispatch();
               this[type].count -= amountToUnload;
               refreshAllResourcesCount();
            }
         }
      }

      private function unloadAllResources(): void
      {
         for each (var transporter: Unit in transporters)
         {
            var ssObject: MSSObject;
            if (inPlanet)
            {
               ssObject = ML.latestPlanet.ssObject;
            }
            var dontCheck: Boolean = !inPlanet || ssObject.metal.unknown;
            var metalToUnload: int = dontCheck
               ? transporter.metal
               : Math.min(ssObject.metal.maxStock - ssObject.metal.currentStock,
                  transporter.metal);
            var energyToUnload: int = dontCheck
               ? transporter.energy
               : Math.min(ssObject.energy.maxStock - ssObject.energy.currentStock,
                  transporter.energy);
            var zetiumToUnload: int = dontCheck
               ? transporter.zetium
               : Math.min(ssObject.zetium.maxStock - ssObject.zetium.currentStock,
                  transporter.zetium);
            if (metalToUnload > 0 || energyToUnload > 0 || zetiumToUnload > 0)
            {
               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: transporter.id,
                     metal: -1 * metalToUnload,
                     energy: -1 * energyToUnload,
                     zetium: -1 * zetiumToUnload
                  }).dispatch();
               metal.count -= metalToUnload;
               energy.count -= energyToUnload;
               zetium.count -= zetiumToUnload;
               refreshAllResourcesCount();
            }
         }
      }

      private function loadResource(type: String): void
      {
         var resourceAmount: int = MLoadableResource(this[type]).count;
         if (resourceAmount <= 0)
         {
            return;
         }
         for each (var transporter: Unit in transporters)
         {
            var freeSpace: int = ML.technologies.getUnitStorage(transporter.type,
               transporter.level) - transporter.stored;
            if (freeSpace > 0)
            {
               var amountToLoad: int = Math.min(resourceAmount,
                  Resource.getResourcesForVolume(freeSpace, type));

               new UnitsCommand(
                  UnitsCommand.TRANSFER_RESOURCES,
                  {
                     transporterId: transporter.id,
                     metal: type == ResourceType.METAL ? amountToLoad : 0,
                     energy: type == ResourceType.ENERGY ? amountToLoad : 0,
                     zetium: type == ResourceType.ZETIUM ? amountToLoad : 0
                  }).dispatch();
               resourceAmount -= amountToLoad;
               if (resourceAmount <= 0)
               {
                  break;
               }
            }
         }
         MLoadableResource(this[type]).count = resourceAmount;
         refreshAllResourcesCount();
      }

      private function updateLoadableUnitCount(type: String,  count: int): void
      {
         for each (var loadable: MLoadable in loadables)
         {
            if (loadable is MLoadableUnit && MLoadableUnit(loadable).type == type)
            {
               loadable.count = count;
               return;
            }
         }
      }

      public function transferAllUnits(): void
      {
         for each (var loadable: MLoadable in loadables)
         {
            if (loadable is MLoadableUnit)
            {
               transferUnits(MLoadableUnit(loadable).type, false);
            }
         }
         updateMinVolume();
      }

      public function transferUnits(type: String, updateVolume: Boolean = true): void
      {
         if (state == STATE_LOADING)
         {
            loadUnits(type);
         }
         else
         {
            unloadUnits(type);
         }
         if (updateVolume)
         {
            updateMinVolume();
         }
      }

      private function unloadUnits(type: String): void
      {
         for each (var transporter: Unit in transporters)
         {
            var unitsToUnload: ListCollectionView = Collections.filter(ML.units,
               function (unit: Unit): Boolean
               {
                  return unit.type == type
                      && unit.location.type == LocationType.UNIT
                      && unit.location.id == transporter.id;
               }
            );
            if (unitsToUnload.length > 0)
            {
               var idArray: Array = [];
               for each (var storedUnit: Unit in unitsToUnload)
               {
                  idArray.push(storedUnit.id);
               }

               new UnitsCommand(UnitsCommand.UNLOAD,
                  {
                     transporterId: transporter.id,
                     unitIds: idArray
                  }).dispatch();
            }
         }
         allUnits.count -= unitsToUnload.length;
         updateLoadableUnitCount(type, 0);
      }

      private function loadUnits(type: String): void
      {
         if (ML.latestPlanet = null)
         {
            resetScreen();
            return;
         }
         var typeUnits: ListCollectionView = Collections.filter(ML.latestPlanet.units,
            function(unit: Unit): Boolean
            {
               return unit.type == type
                   && unit.level > 0
                   && unit.owner == Owner.PLAYER;
            }
         );
         var unitVolume: int = Config.getUnitVolume(type);
         var totalVolume: int = unitVolume * typeUnits.length;
         var currentIndex: int = 0;
         var currentLoadable: int = 0;
         while (totalVolume > 0 && currentIndex < transporters.length)
         {
            var transporter: Unit = Unit(transporters.getItemAt(currentIndex));
            var freeSpace: int = ML.technologies.getUnitStorage(transporter.type,
               transporter.level) - transporter.stored;
            var unitsToLoad: Array = [];
            while (freeSpace >= unitVolume && totalVolume > 0)
            {
               var lUnit: Unit = Unit(typeUnits.getItemAt(currentLoadable));
               unitsToLoad.push(lUnit.id);
               allUnits.count--;
               currentLoadable++;
               freeSpace -= unitVolume;
               totalVolume -= unitVolume;
            }
            if (unitsToLoad.length > 0)
            {
               new UnitsCommand(UnitsCommand.LOAD,
                  {
                     transporterId: transporter.id,
                     unitIds: unitsToLoad
                  }).dispatch();
               transporter.stored += (unitVolume * unitsToLoad.length);
            }
            currentIndex++;
         }
         updateLoadableUnitCount(type,  typeUnits.length - currentLoadable);
      }

   }
}
