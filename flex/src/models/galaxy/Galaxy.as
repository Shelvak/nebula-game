package models.galaxy
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.ModelsCollection;
   import models.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   import utils.ClassUtil;
   
   
   /**
    * Dispatched when galaxy dimensions have changed.
    * 
    * @eventType models.events.GalaxyEvent.RESIZE
    */
   [Event(name="resize", type="models.events.GalaxyEvent")]
   
   /**
    * Dispatched when new solar system has been added to this galaxy. Is not dispatched when
    * <code>solarSystems</code> property is set.
    * 
    * @eventType models.events.GalaxyEvent.SOLAR_SYSTEM_ADD
    */
   [Event(name="solarSystemAdd", type="models.events.GalaxyEvent")]
   
   /**
    * Dispatched when a solar system has been removed from this galaxy. Is not dispatched when
    * <code>solarSystems</code> property is set.
    * 
    * @eventType models.events.GalaxyEvent.SOLAR_SYSTEM_REMOVE
    */
   [Event(name="solarSystemRemove", type="models.events.GalaxyEvent")]
   
   /**
    * A galaxy. 
    */
   [Bindable]
   public class Galaxy extends Map
   {
      private var _fowMatrixBuilder:FOWMatrixBuilder;
      
      
      [Bindable(event="resize")]
      public function get bounds() : Rectangle
      {
         return _fowMatrixBuilder.getBounds();
      }
      
      
      [Bindable(event="resize")]
      public function get offset() : Point
      {
         return _fowMatrixBuilder.getCoordsOffset();
      }
      
      
      public function get fowMatrix() : Vector.<Vector.<Boolean>>
      {
         return _fowMatrixBuilder.getMatrix();
      }
      
      
      public function setFOWEntries(fowEntries:Vector.<Rectangle>) : void
      {
         _fowMatrixBuilder = new FOWMatrixBuilder(fowEntries);
         dispatchResizeEvent();
      }
      
      
      private var _solarSystems:ModelsCollection = new ModelsCollection();
      /**
       * Collection of solar systems this galaxy consists of.
       * <p>
       * Items of the collection are of <code>SolarSystem</code> type.
       * </p>
       * 
       * @default empty collection
       */
      public function set solarSystems(value:ModelsCollection) : void
      {
         if (value != _solarSystems)
         {
            _solarSystems = value;
            dispatchObjectsListChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get solarSystems() : ModelsCollection
      {
         return _solarSystems;
      }
      
      
      /**
       * Looks and returns for a solar system with a given id
       * @param id
       * @return instance of <code>SolarSystem</code> or <code>null</code>
       * if a solar system with given id does not exists. 
       * 
       */
      public function getSSById(id:int) : SolarSystem
      {
         return solarSystems.findModel(id);
      }
      
      
      public function addSolarSystem(solarSystem:SolarSystem) : void
      {
         ClassUtil.checkIfParamNotNull("solarSystem", solarSystem);
         _solarSystems.addItem(solarSystem);
         dispatchSolarSystemAddEvent(solarSystem);
      }
      
      
      /**
       * Removes a given solar system (if one exists) form this galaxy. 
       */
      public function removeSolarSystem(solarSystem:SolarSystem) : void
      {
         if (solarSystems.contains(solarSystem))
         {
            solarSystems.removeItem(solarSystem);
            dispatchSolarSystemRemoveEvent(solarSystem);
         }
      };
      
      
      [Bindable(event="mapObjectsListChange")]
      /**
       * Returns same collection as <code>solarSystems</code>.
       * 
       * @see models.map.Map#objects
       * @see models.Galaxy#solarSystems
       */
      public override function get objects() : ArrayCollection
      {
         return solarSystems;
      };
      
      
      protected override function get innerMaps() : ListCollectionView
      {
         return solarSystems;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int
      {
         return MapType.GALAXY;
      };
      
      
      /**
       * Galaxy locations are not bounded to visible map square.
       */
      public override function definesLocation(location:LocationMinimal) : Boolean
      {
         return location.type == LocationType.GALAXY && location.id == id;
      }
      
      
      /**
       * Basicly does the same as <code>definesLocation()</code> but takes fog of war into account.
       */
      public function locationIsVisible(location:LocationMinimal) : Boolean
      {
         if (definesLocation(location))
         {
            var fowMatrix:Vector.<Vector.<Boolean>> = _fowMatrixBuilder.getMatrix();
            return fowMatrix[location.x + offset.x][location.y + offset.y];
         }
         return false;
      }
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.GALAXY;
      }
      
      
      protected override function setCustomLocationFields(location:Location) : void
      {
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchResizeEvent() : void
      {
         if (hasEventListener(GalaxyEvent.RESIZE))
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.RESIZE));
         }
      }
      
      
      private function dispatchSolarSystemAddEvent(solarSystem:SolarSystem) : void
      {
         if (hasEventListener(GalaxyEvent.SOLAR_SYSTEM_ADD))
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_ADD, solarSystem));
         }
      }
      
      
      private function dispatchSolarSystemRemoveEvent(solarSystem:SolarSystem) : void
      {
         if (hasEventListener(GalaxyEvent.SOLAR_SYSTEM_REMOVE))
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_REMOVE, solarSystem));
         }
      }
   }
}