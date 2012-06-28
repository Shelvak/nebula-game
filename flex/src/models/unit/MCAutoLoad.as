/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:10 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.events.EventDispatcher;

   import models.ModelLocator;
   import models.Owner;
   import models.factories.UnitFactory;

   import models.location.ILocationUser;
   import models.location.Location;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.ModelUtil;
   import utils.SingletonFactory;

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

      public function prepare(_transporters: Array, sLocation: *,
                               sTarget: *): void
      {
         location = sLocation;
         target = sTarget;
         transporters = new ArrayCollection(_transporters);
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
         temp.addItem(allUnits);
         if (target == null)
         {
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
         else
         {

         }
         loadables = temp;
      }

   }
}
