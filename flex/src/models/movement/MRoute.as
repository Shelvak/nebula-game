package models.movement
{
   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.Owner;
   import models.location.ILocationUser;
   import models.location.Location;
   import models.movement.events.MRouteEvent;
   import models.player.PlayerMinimal;
   import models.time.MTimeEventFixedMoment;
   import models.unit.UnitBuildingEntry;

   import mx.collections.ArrayCollection;

   import utils.datastructures.Collections;


   /**
    * @see models.movement.events.MRouteEvent#JUMPS_AT_CHANGE
    */
   [Event(name="jumpsAtChange", type="models.movement.events.MRouteEvent")]
   
   /**
    * Should only be used to store additional information about squadrons
    * belonging to either the player or his/her allies.
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
      
      
      [Required(alias="arrivesAt")]
      [Bindable(event="willNotChange")]
      /**
       * Time (local) when this squadron will reach its destination.
       */
      public var arrivalEvent: MTimeEventFixedMoment = null;
      
      private var _jumpsAtEvent: MTimeEventFixedMoment = null;
      [Optional(alias="jumpsAt")]
      [Bindable(event="jumpsAtChange")]
      /**
       * Time (local) when this squadron will do a jump to another map.
       */
      public function set jumpsAtEvent(value: MTimeEventFixedMoment): void {
         if (_jumpsAtEvent != value) {
            _jumpsAtEvent = value;
            dispatchSimpleEvent(MRouteEvent, MRouteEvent.JUMPS_AT_CHANGE);
         }
      }
      public function get jumpsAtEvent(): MTimeEventFixedMoment {
         return _jumpsAtEvent;
      }

      [Bindable(event="jumpsAtChange")]
      /**
       * Is this squadron going to jump to another map?
       */
      public function get jumpPending(): Boolean {
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


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function resetChangeFlags(): void {
         if (arrivalEvent != null) {
            arrivalEvent.resetChangeFlags();
         }
         if (_jumpsAtEvent != null) {
            _jumpsAtEvent.resetChangeFlags();
         }
      }

      public function update(): void {
         if (arrivalEvent != null) {
            arrivalEvent.update();
         }
         if (_jumpsAtEvent != null) {
            _jumpsAtEvent.update();
         }
         dispatchUpdateEvent();
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

      public override function afterCreate(data: Object): void {
         super.afterCreate(data);
         if (sourceLocation != null && sourceLocation.isSSObject) {
            sourceLocation.setDefaultCoordinates();
         }
         if (currentLocation != null && currentLocation.isSSObject) {
            currentLocation.setDefaultCoordinates();
         }
         if (targetLocation != null && targetLocation.isSSObject) {
            targetLocation.setDefaultCoordinates();
         }
      }
   }
}