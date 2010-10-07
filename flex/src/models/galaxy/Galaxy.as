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
   
   import namespaces.client_internal;
   
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
//      [Bindable(event="resize")]
//      /**
//       * Minimum x value of a solar system tile in this galaxy.
//       */
//      public var minX: int = 0;
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * Maximum x value of a solar system tile in this galaxy. 
//       */
//      public var maxX: int = 0;
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * Minimum y value of a solar system tile in this galaxy.
//       */      
//      public var minY: int = 0;
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * Minimum y value of a solar system tile in this galaxy. 
//       */
//      public var maxY: int = 0;
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * Width of galaxy in tiles.
//       * 
//       * @default 0
//       */
//      public function get width () :int
//      {
//         return maxX - minX + 1;
//      }
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * Height of a galaxy in tiles.
//       * 
//       * @default 0 
//       */
//      public function get height () :int
//      {
//         FOWMatrixBuilder
//         return maxY - minY + 1;
//      }
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * -minX. Need this because server assumes that galaxy center is in the
//       * center of a plane while client thinks it is the top left corner of
//       * a plane. 
//       */
//      public function get xOffset () :int
//      {
//         return -minX;
//      }
//      
//      
//      [Bindable(event="resize")]
//      /**
//       * -minY. Need this because server assumes that galaxy center is in the
//       * center of a plane while client thinks it is the top left corner of
//       * a plane.
//       */
//      public function get yOffset () :int
//      {
//         return -minY;
//      }
//      
//      
//      /**
//       * Sets <code>minX</code>, <code>minY</code>, <code>maxX</code> and <code>maxY</code>
//       * properties. Values are determined from the list of solar systems.
//       * <p>This operation is expensive in terms of performance so it is not
//       * called every time a solar system is added to a galaxy. Instead you
//       * should call this method when you have altered a list of solar systems
//       * for the last time. When <code>solarSystems</code> property is changed
//       * (nor <code>addSolarSystem</code> neither <code>removeSolarSystem</code>
//       * methods are used) this method is called automaticly.</p>
//       */      
//      client_internal function setMinMaxProperties () :void
//      {
//         dispatchEvent(new GalaxyEvent(GalaxyEvent.RESIZE));
//         dispatchPropertyUpdateEvent("minX", minX);
//         dispatchPropertyUpdateEvent("maxX", maxX);
//         dispatchPropertyUpdateEvent("minY", minY);
//         dispatchPropertyUpdateEvent("maxY", maxY);
//         dispatchPropertyUpdateEvent("width", width);
//         dispatchPropertyUpdateEvent("height", height);
//         dispatchPropertyUpdateEvent("xOffset", xOffset);
//         dispatchPropertyUpdateEvent("yOffset", yOffset);
//      }
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
         dispatchEvent(new GalaxyEvent(GalaxyEvent.RESIZE));
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
         dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_ADD, solarSystem));
      }
      
      
      /**
       * Removes a given solar system (if one exists) form this galaxy. 
       */
      public function removeSolarSystem(solarSystem:SolarSystem) : void
      {
         if (solarSystems.contains(solarSystem))
         {
            solarSystems.removeItem(solarSystem);
            dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_REMOVE, solarSystem));
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
   }
}