package components.unitsscreen.events
{
   import flash.events.Event;
   
   import mx.collections.ListCollectionView;
   
   public class UnitsScreenEvent extends Event
   {
      public static const INVALIDATE_SIDEBAR_STATE: String = 'invalidateSidebarState';
      
      public static const ATTACK_INITIATED: String = 'deselectInitiated';
      
      public static const SET_UNITS: String = 'setUnits';
      
      public static const FLANK_SELECT_ALL: String = 'flankSelectAll';
      public static const FLANK_DESELECT: String = 'flankDeselect';
      
      public var units: ListCollectionView;
      
      public function UnitsScreenEvent(type:String, unitsCollection: ListCollectionView = null)
      {
         if (type == SET_UNITS)
         {
            units = unitsCollection;
         }
         super(type, false, false);
      }
   }
}