/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:10 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import config.Config;

   import controllers.units.UnitsCommand;

   import flash.events.EventDispatcher;

   import models.ModelLocator;
   import models.Owner;
   import models.factories.UnitFactory;

   import models.location.ILocationUser;
   import models.location.Location;
   import models.location.LocationType;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.ModelUtil;
   import utils.SingletonFactory;
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

      private function resetScreen(): void
      {
         var temp: ArrayCollection = new ArrayCollection();
         var allResources: MLoadableAllResources = new MLoadableAllResources();
         var metal: MLoadableResource = new MLoadableResource(ResourceType.METAL);
         var energy: MLoadableResource = new MLoadableResource(ResourceType.ENERGY);
         var zetium: MLoadableResource = new MLoadableResource(ResourceType.ZETIUM);
         var allUnits: MLoadableAllUnits = new MLoadableAllUnits();
         temp.addItem(allResources);
         temp.addItem(metal);
         temp.addItem(energy);
         temp.addItem(zetium);
         if (target == null && Location(location).type == LocationType.SS_OBJECT)
         {
            temp.addItem(allUnits);
            var ssObject: MSSObject = ML.latestPlanet.ssObject;
            metal.count = ssObject.metal.currentStock;
            energy.count = ssObject.energy.currentStock;
            zetium.count = ssObject.zetium.currentStock;
            allResources.count = metal.count + energy.count + zetium.count;
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
         }
         else if (target == null)
         {
            //TODO: Loading everything from space sector
         }
         else if (location == null && Location(target).type == LocationType.SS_OBJECT)
         {
            temp.addItem(allUnits);
            //TODO: Unloading everything to ss object
         }
         else
         {
            //TODO: Unloading everything to space sector
         }
         loadables = temp;
      }

      public function unloadUnits(type: String): void
      {
         for each (var transporter: Unit in transporters)
         {
            
         }
      }

      public function loadUnits(type: String): void
      {
         var units: ListCollectionView = ML.latestPlanet.getActiveUnits(
            Owner.PLAYER, UnitKind.GROUND);
         var typeUnits: ListCollectionView = Collections.filter(units,
            function(unit: Unit): Boolean
            {
               return unit.type == type;
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
            }
            currentIndex++;
         }
      }

   }
}
