package models.movement
{
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.Location;
   import models.player.PlayerMinimal;
   import models.unit.UnitBuildingEntry;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Should only be used to store additional information about squadrons belonging to either the
    * palyer or his/her allies.
    */
   public class MRoute extends BaseModel
   {
      public function MRoute()
      {
         super();
      }
      
      
      [Required]
      [Bindable]
      /**
       * Id of a player this route belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * @default 0
       */
      public var playerId:int = 0;
      
      
      [Optional]
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
      
      
      [Required]
      [Bindable]
      /**
       * Owner type of this route.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * Will throw <code>IllegalArgumentError</code> if you try setting this to something other that
       * <code>Owner.PLAYER</code> or <code>Owner.ALLY</code>
       */
      private var _owner:int = Owner.PLAYER;
      public function set owner(value:int) : void
      {
         if (value != Owner.PLAYER && value != Owner.ALLY)
         {
            throw new ArgumentError(
               "MRoute.owner can only be set to Owner.PLAYER (" + Owner.PLAYER + ") or Owner.ALLY (" +
               Owner.ALLY + "): was " + value
            );
         }
         if (_owner != value)
         {
            _owner = value;
         }
      }
      public function get owner() : int
      {
         return _owner;
      }
      
      
      [Required]
      [Bindable]
      /**
       * Time (local) when this squadron will reach its destination.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]
       * </i></p>
       * 
       * @default null
       */
      public var arrivesAt:Date = null;
      
      
      [Required]
      [Bindable]
      /**
       * Time (local) when this squadron will do first hop.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]
       * </i></p>
       * 
       * @default null
       */
      public var firstHop:Date = null;
      
      
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
      public var cachedUnits:ModelsCollection = new ModelsCollection();
      
      
      /**
       * Looks for and returns <code>UnitBuildingEntry</code> which has <code>type</code> equal to <code>unitType</code>.
       * 
       * @param unitType type of a unit in a squadron
       * 
       * @return instance of <code>UnitBuildingEntry</code> or <code>null</code> if search has failed
       * 
       * @throws ArgumentError if <code>unitType</code> is <code>null</code>
       */
      public function findEntryByType(unitType:String) : UnitBuildingEntry
      {
         return Collections.findFirst(cachedUnits,
            function(entry:UnitBuildingEntry) : Boolean
            {
               return entry.type == unitType;
            }
         );
      }
   }
}