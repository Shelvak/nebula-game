package models.quest.events
{
   import flash.events.Event;
   
   public class QuestEvent extends Event
   {
      public static const STATUS_CHANGE:String = "statusChange";
      
      public static const REFRESH_REQUESTED:String = "refreshRequested";
      
      public static const SCROLL_REQUESTED:String = "scrollRequested";
      
      public var index: int;
      
      public function QuestEvent(type:String, _index: int = -1)
      {
         index = _index;
         super(type, false, false);
      }
   }
}