package models.movement
{
   import interfaces.IUpdatable;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.ILocationUser;
   import models.location.Location;
   import models.movement.events.MRouteEvent;
   import models.player.PlayerMinimal;
   import models.time.MTimeEventFixedMoment;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.datastructures.Collections;
   
   
   /**
    * @see models.movement.event.MRouteEvent#JUMPS_AT_CHANGE
    */
   [Event(name="jumpsAtChange", type="models.movement.events.MRouteEvent")]
   
   /**
    * Should only be used to store additional information about squadrons belonging to either the
    * palyer or his/her allies.
    */
   public class MRoute extends BaseModel implements IUpdatable, ILocationUser
   {
      public function MRoute() {
         super();
      }
      
      [Required]
      [Bindable]
      /**
       * Player who owns this route.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * @default 0
       */
      public var player:PlayerMinimal = null;
      
      private var _owner:int = Owner.PLAYER;
      [Optional(alias="status")]
      [Bindable]
      /**
       * Owner type of this route.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable]</i></p>
       * 
       * Will throw <code>IllegalArgumentError</code> if you try setting this to something other that
       * <code>Owner.PLAYER</code> or <code>Owner.ALLY</code>
       */
      public function set owner(value:int) : void {
         if (_owner != value)
            _owner = value;
      }
      /**
       * @private
       */
      public function get owner() : int {
         return _owner;
      }
      
      
      [Bindable]
      /**
       * Time (local) when this squadron will reach its destination.
       */
      public var arrivalEvent:MTimeEventFixedMoment = null;
      
      
      private var _jumpsAtEvent:MTimeEventFixedMoment = null;
      [Bindable(event="jumpsAtChange")]
      /**
       * Time (local) when this squadron will do a jump to another map.
       */
      public function set jumpsAtEvent(value:MTimeEventFixedMoment) : void {
         if (_jumpsAtEvent != value) {
            _jumpsAtEvent = value;
            dispatchSimpleEvent(MRouteEvent, MRouteEvent.JUMPS_AT_CHANGE);
         }
      }
      public function get jumpsAtEvent() : MTimeEventFixedMoment {
         return _jumpsAtEvent;
      }
      
      [Bindable(event="jumpsAtChange")]
      /**
       * Is this squadron going to jump to another map?
       */
      public function get jumpPending() : Boolean {
         return _jumpsAtEvent != null;
      }
      
      
      [Required(alias="source")]
      [Bindable]
      /**
       * Location from which units travelling this route have been dispatched (where order has been issued).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="source")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var sourceLocation:Location = null;
      
      
      [Required(alias="target")]
      [Bindable]
      /**
       * Final destination of units travelling the route. If not known - <code>null</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="target")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var targetLocation:Location = null;
      
      
      
      [Required(alias="current")]
      [Bindable]
      /**
       * Current location of units travelling the route.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="current")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var currentLocation:Location = null;
      
      
      [Bindable]
      /**
       * Collection of <code>UnitBuildingEntry</code> instances.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       * 
       * @default empty collection
       */
      public var cachedUnits: ArrayCollection = new ArrayCollection();
      
      
      /**
       * Looks for and returns <code>UnitBuildingEntry</code> which has <code>type</code> equal to <code>unitType</code>.
       * 
       * @param unitType type of a unit in a squadron
       * 
       * @return instance of <code>UnitBuildingEntry</code> or <code>null</code> if search has failed
       * 
       * @throws ArgumentError if <code>unitType</code> is <code>null</code>
       */
      public function findEntryByType(unitType:String) : UnitBuildingEntry {
         return Collections.findFirst(cachedUnits,
            function(entry:UnitBuildingEntry) : Boolean {
               return entry.type == unitType;
            }
         );
      }
      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */
      
      public function resetChangeFlags() : void {
         if (arrivalEvent != null) {
            arrivalEvent.resetChangeFlags();
         }
         if (_jumpsAtEvent != null) {
            _jumpsAtEvent.resetChangeFlags();
         }
      }
      
      public function update() : void {
         if (arrivalEvent != null) {
            arrivalEvent.update();
         }
         if (_jumpsAtEvent != null) {
            _jumpsAtEvent.update();
         }
      }
      
      
      /* ##################### */
      /* ### ILocationUser ### */
      /* ##################### */
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(currentLocation, id, name);
         Location.updateName(sourceLocation,  id, name);
         Location.updateName(targetLocation,  id, name);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      protected override function afterCreateModel(data:Object) : void {
         super.afterCreateModel(data);
         if (sourceLocation.isSSObject)  sourceLocation.setDefaultCoordinates();
         if (currentLocation.isSSObject) currentLocation.setDefaultCoordinates();
         if (targetLocation.isSSObject)  currentLocation.setDefaultCoordinates();
         var arrivesAt:String = Objects.notNull(
            data["arrivesAt"],
            "[prop arrivesAt] is required by [class: MRoute] but was not present in source object. " +
            "The object was:\n" + ObjectUtil.toString(data)
         );
         arrivalEvent = new MTimeEventFixedMoment();
         arrivalEvent.occuresAt = DateUtil.parseServerDTF(arrivesAt);
         if (data["jumpsAt"] != null) {
            _jumpsAtEvent = new MTimeEventFixedMoment();
            _jumpsAtEvent.occuresAt = DateUtil.parseServerDTF(data["jumpsAt"]);
         }
      }
   }
}