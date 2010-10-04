package models.quest.events
{
   import flash.events.Event;
   
   public class QuestEvent extends Event
   {
      public static const STATUS_CHANGE:String = "statusChange";
      
      public static const REFRESH_REQUESTED:String = "refreshRequested";
      
      
      public function QuestEvent(type:String)
      {
         super(type, false, false);
      }
   }
}