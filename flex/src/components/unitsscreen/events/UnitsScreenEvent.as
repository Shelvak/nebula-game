package components.unitsscreen.events
{
   import flash.events.Event;
   
   import mx.collections.ListCollectionView;
   
   public class UnitsScreenEvent extends Event
   {
      public static const INVALIDATE_SIDEBAR_STATE: String = 'invalidateSidebarState';
      
      public static const ATTACK_INITIATED: String = 'deselectInitiated';
      
      public static const FLANK_SELECT_ALL: String = 'flankSelectAll';
      public static const FLANK_DESELECT: String = 'flankDeselect';
      
      public function UnitsScreenEvent(type:String)
      {
         super(type, false, false);
      }
   }
}