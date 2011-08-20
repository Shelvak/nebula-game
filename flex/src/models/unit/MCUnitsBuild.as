package models.unit
{
   import flash.events.EventDispatcher;
   
   import models.unit.events.UnitEvent;
   
   import utils.SingletonFactory;
   
   public class MCUnitsBuild extends EventDispatcher
   {
      public static function getInstance(): MCUnitsBuild
      {
         return SingletonFactory.getSingletonInstance(MCUnitsBuild);
      }
      
      public var facilityId: int = -1;
      
      [Bindable]
      public var cancelId: int = -1;
      
      public function openFacility(): void
      {
         if (hasEventListener(UnitEvent.OPEN_FACILITY))
         {
            dispatchEvent(new UnitEvent(UnitEvent.OPEN_FACILITY));
         }
      }
   }
}