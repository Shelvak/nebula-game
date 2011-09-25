package components.unitsscreen.events
{
   import flash.events.Event;
   
   import mx.collections.ListCollectionView;
   
   public class UnitsScreenEvent extends Event
   {
      public static const INVALIDATE_SIDEBAR_STATE: String = 'invalidateSidebarState';
      
      public static const ATTACK_INITIATED: String = 'deselectInitiated';
      public static const FORMATION_CHANGE: String = 'formationChange';
      public static const UNIT_COUNT_CHANGE: String = 'unitsChange';
      public static const HEALING_PRICE_CHANGE: String = 'healingPriceChange';
      public static const FLANK_MODEL_CHANGE: String = 'flankModelChange';
      public static const SELECTION_CHANGE: String = 'selectionChange';
      public static const SET_STANCE: String = 'setStance';
      public static const DROP_UNITS: String = 'dropUnits';
      
      
      public var stance: int;
      
      
      
      public function UnitsScreenEvent(type:String, _stance: int = 0)
      {
         stance = _stance;
         super(type, false, false);
      }
   }
}