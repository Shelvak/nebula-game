package components.dailybonus
{
   import flash.events.Event;
   
   public class DailyBonusEvent extends Event
   {
      public static const CLOSE_PANEL: String = 'closeDailyBonusPanelEvent';
      public function DailyBonusEvent(type:String)
      {
         super(type, false, false);
      }
   }
}