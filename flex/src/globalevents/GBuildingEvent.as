package globalevents
{
   import models.building.Building;
   
   public class GBuildingEvent extends GlobalEvent
   {   
      /**
       * Dispatched when building is activated/deactivated
       * 
       * @eventType buildingActiveStateChanged
       */
      public static const BUILDING_ACTIVATION: String = "buildingActiveStateChanged";
      
      /**
       * Dispatched when user clicks on an empty space on the map to start
       * construction of a building.
       * 
       * @eventType contructionCommit
       */
      public static const CONSTRUCTION_COMMIT:String = "contructionCommit";
      
      
      /**
       * Dispatched when server approves upgrade of a building.
       * 
       * @eventType buildingUpgradeApproved
       */
      public static const UPGRADE_APPROVED:String = "buildingUpgradeApproved";
      
      
      /**
       * Dispatched when a building must be opened.
       * 
       * @eventType openBuilding
       */
      public static const OPEN:String = "openBuilding";
      
      
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
      
      public function GBuildingEvent(type:String, b:Building = null, constructorId:int = 0, eagerDispatch:Boolean=true)
      {
         _building = b;
         _facilityId = constructorId;
         super(type, eagerDispatch);
      }
   }
}