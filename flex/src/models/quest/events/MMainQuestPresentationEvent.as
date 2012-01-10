package models.quest.events
{
   import flash.events.Event;


   public class MMainQuestPresentationEvent extends Event
   {
      public static const CURRENT_SLIDE_CHANGE:String = "currentSlideChange";

      public function MMainQuestPresentationEvent(type:String) {
         super(type);
      }
   }
}
