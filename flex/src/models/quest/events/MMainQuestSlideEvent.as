package models.quest.events
{
   import flash.events.Event;


   public class MMainQuestSlideEvent extends Event
   {
      public static const VISIBLE_CHANGE:String = "visibleChange";

      public function MMainQuestSlideEvent(type:String) {
         super(type);
      }
   }
}
