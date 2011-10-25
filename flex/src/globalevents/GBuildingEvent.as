package globalevents
{
   import models.building.Building;
   
   public class GBuildingEvent extends GlobalEvent
   {
      /**
       * Dispatched when server responds to queue move command of building
       * 
       * @eventType queueAproved
       */
      public static const QUEUE_APROVED:String = "queueAproved";
      
      
      /**
       * Dispatched when user clicks on an empty space on the map to start
       * construction of a building.
       * 
       * @eventType contructionCommit
       */
      public static const CONSTRUCTION_COMMIT:String = "contructionCommit";
      
      
      /**
       * Dispatched when user clicks on not empty space on the map and construction of a building
       * needs to be canceled.
       * 
       * @eventType contructionCancel
       */
      public static const CONSTRUCTION_CANCEL:String = "contructionCancel";
      
      
      /**
       * Dispatched when server approves upgrade of a building.
       * 
       * @eventType buildingUpgradeApproved
       */
      public static const UPGRADE_APPROVED:String = "buildingUpgradeApproved";
      
      
      /**
       * Dispatched when process of moving a building to another place is initiated by a user.
       * This is dispatched by the <code>BuildingsSidebar</code> (or its subpart). It is received by
       * <code>BuildingsLayer</code>. Following parameters must be provided:
       * <ul>
       *    <li><code>building</code> - model of a building to be moved. <b>Not null</b>.</li>
       * </ul>
       * 
       * @eventType GBuildingEvent_moveInit
       */
      public static const MOVE_INIT:String = "GBuildingEvent_moveInit";
      
      
      /**
       * Dispatched when server has confirmed movement of a building to another place.
       * <code>building</code> is set to a building model which has been moved.
       * 
       * @eventType GBuildingEvent_moveConfirm
       */
      public static const MOVE_CONFIRM:String = "GBuildingEvent_moveConfirm";
      
      
      /**
       * Dispatched when server or user has canceled movement of a building to another place.
       * <code>building</code> is set to a building model which has not been moved.
       * 
       * @eventType GBuildingEvent_moveCancel
       */
      public static const MOVE_CANCEL:String = "GBuildingEvent_moveCancel";
      
      
      private var _facilityId: int;
      
      public function get facilityId(): int
      {
         return _facilityId;
      }
      
      private var _building:Building;
      public function get building(): Building
      {
         return _building;
      }
      
      public function GBuildingEvent(type:String,
                                     b:Building = null,
                                     constructorId:int = 0,
                                     eagerDispatch:Boolean = true)
      {
         _building = b;
         _facilityId = constructorId;
         super(type, eagerDispatch);
      }
   }
}