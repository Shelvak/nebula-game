package components.unitsscreen.events
{
   import mx.collections.ArrayCollection;
   
   import flash.events.Event;
   
   public class UnitsScreenEvent extends Event
   {
      public static const INVALIDATE_SIDEBAR_STATE: String = 'invalidateSidebarState';
      
      public static const ATTACK_INITIATED: String = 'deselectInitiated';
      
      public static const SET_UNITS: String = 'setUnits';
      
      public var units: ArrayCollection;
      
      public function UnitsScreenEvent(type:String, unitsCollection: ArrayCollection = null)
      {
         if (type == SET_UNITS)
         {
            units = unitsCollection;
         }
         super(type, false, false);
      }
   }
}