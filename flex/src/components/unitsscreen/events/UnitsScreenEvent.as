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
      public static const FORMATION_CHANGE: String = 'formationChange';
      public static const UNIT_COUNT_CHANGE: String = 'unitsChange';
      public static const FLANK_MODEL_CHANGE: String = 'flankModelChange';
      public static const SELECTION_CHANGE: String = 'unitsChange';
      
      
      
      
      
      public function UnitsScreenEvent(type:String)
      {
         super(type, false, false);
      }
   }
}